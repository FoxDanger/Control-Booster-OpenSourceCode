// dllmain.cpp : Defines the entry point for the DLL application.
#include "pch.h"
#include "dllmain.h"
#include <string>
#include <vector>
#include <thread>
#include "osc/OscReceivedElements.h"
#include "osc/OscPacketListener.h"
#include "osc/OscOutboundPacketStream.h"
#include "ip/UdpSocket.h"

//Class from OSC library (oscpack). This calls our handleOscMsg() on every new message.
class ThePacketListener : public osc::OscPacketListener {
protected:

    virtual void ProcessMessage(const osc::ReceivedMessage& m,
        const IpEndpointName& remoteEndpoint)
    {
        (void)remoteEndpoint; // suppress unused parameter warning

        try { 
            handleOscMsg(m); 
        }
        catch (osc::Exception& e) {
            // any parsing errors such as unexpected argument types, or 
            // missing arguments get thrown as exceptions.
            OutputDebugString(L"ProcessMessage: Error while parsing message: ...");
        }
    }
};

/* Definition and declaration of the registered OSC Listeners. 
* Contains OSC addresses to listen to and OS message ID to send for each 
* address. These are populated from the AHK script! */
struct Listener {
    std::string address;
    unsigned int dataType;
    unsigned int message;
};
std::vector<Listener> listeners;
/* Definition and declaration of the array buffer for received OSC Strings.
* All received OSC strings that match a listener are stored here until they are
* fetched by the calling script. */
struct StoredString {
    std::string string;
    int id;
};
std::vector<StoredString> storedStrings;
const int storedStringsMaxSize = 100;
/* Handle to the calling window, also indicates if this OSC receiver is "opened" by being != NULL*/
HWND hwnd = NULL;
/* OSC receiving objects and thread.
* From within these, our handleOscMsg() function is called. */
ThePacketListener* thePacketListener;
UdpListeningReceiveSocket* sock;
std::thread* oscThread;

/* The OSC Thread. Has to be another thread, because
*  UdpListeningReceiveSocket runs in a blocking loop. [RunUntilSigInt()]*/
void runOscThread(unsigned int port)
{
    if (!thePacketListener)
        thePacketListener = new ThePacketListener;

    if (sock) sock->~UdpListeningReceiveSocket();
    try {
        sock = new UdpListeningReceiveSocket(
            IpEndpointName(IpEndpointName::ANY_ADDRESS, port),
            thePacketListener);
        sock->RunUntilSigInt(); //<<--- this is the loop
    }
    catch (std::runtime_error)
    {
        OutputDebugString(L"Unable to open port!\r\n");
    }
}

/* DLL was loaded */
BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        break;
    case DLL_THREAD_ATTACH:
        break;
    case DLL_THREAD_DETACH:
        break;
    case DLL_PROCESS_DETACH:
        close();
        break;
    }
    return TRUE;
}

DLLEXPORT int open(HWND targetWindowHandle, unsigned int port)
{
    OutputDebugString(L"open()\r\n");
    if (!targetWindowHandle || !port) {
        if (!targetWindowHandle) OutputDebugString(L"open: targetWindowHandle!!\r\n");
        if (!port) OutputDebugString(L"open: port!!\r\n");
        return 1;
    }

    unsigned int timeout = 500; //timout for port opening, in ms

    /*Store handle to Autohotkey window globally*/
    hwnd = targetWindowHandle;
    /*Start OSC Thread*/
    oscThread = new std::thread(runOscThread, port);

    while ((!sock || !sock->IsBound()) && timeout)
    {
        timeout--;
        Sleep(1);
    }
    if (!sock || !sock->IsBound())
    {
        OutputDebugString(L"open: cannot open port!!\r\n");
        return 2;
    }
    
    OutputDebugString(L"open: Opened.\r\n");
    return 0;
}

DLLEXPORT int close(unsigned int clearListeners)
{
    if (sock) 
    {
        sock->AsynchronousBreak();
    }
    oscThread->join();
    oscThread = NULL;
    hwnd = NULL;
    if (clearListeners) listeners.clear();
    storedStrings.clear();
    return 0;
}

DLLEXPORT int addListener(LPCSTR address_, unsigned int messageID_, unsigned int dataType_)
{
    OutputDebugString(L"addListener: address=");
    OutputDebugStringA(address_);
    OutputDebugString(L"\r\n");
    listeners.push_back(Listener{ std::string(address_), dataType_, messageID_ });
    return 0;
}

DLLEXPORT int removeListener(LPCSTR address_)
{
    UINT result = 1;
    std::string addrStr(address_);
    //All OSC addresses have to start with a '/'
    if (addrStr[0] != '/') addrStr.insert(0, "/");

    for (UINT i = 0; i < listeners.size(); i++)
    {
        if (listeners[i].address == addrStr)
        {
            listeners.erase(listeners.begin() + i);
            i--; //one step backward, what previously was i+1 is i after erase().
            result = 0; //Found at least one occurence
        }
    }
    return result;
}

DLLEXPORT char* getStringData(char* targetString, unsigned int targetSize, unsigned int stringId)
{
    for (UINT i = 0; i < storedStrings.size(); i++)
    {
        if (storedStrings[i].id == stringId)
        {
            if (storedStrings[i].string.length() < targetSize) //Avoid runtime error. 
                strcpy_s(targetString, targetSize, storedStrings[i].string.c_str());
            else
                strcpy_s(targetString, targetSize, "\0"); //String doesnt fit, return empty string"
            storedStrings.erase(storedStrings.begin() + i);
            return targetString;
        }
    }
    //Return empty string if nothing was found.
    strcpy_s(targetString, targetSize, "\0");
    return targetString;
}

DLLEXPORT void sendOscMessageInt(char* ip, unsigned int port, char* address, int payload)
{
    UdpTransmitSocket transmitSocket(IpEndpointName(ip, port));
    char buffer[1024];
    osc::OutboundPacketStream p(buffer, 1024);
    p << osc::BeginMessage(address) << payload << osc::EndMessage;

    transmitSocket.Send(p.Data(), p.Size());
}

DLLEXPORT void sendOscMessageFloat(char* ip, unsigned int port, char* address, float payload)
{
    UdpTransmitSocket transmitSocket(IpEndpointName(ip, port));
    char buffer[1024];
    osc::OutboundPacketStream p(buffer, 1024);
    p << osc::BeginMessage(address) << payload << osc::EndMessage;

    transmitSocket.Send(p.Data(), p.Size());
}

DLLEXPORT void sendOscMessageString(char* ip, unsigned int port, char* address, char* payload)
{
    UdpTransmitSocket transmitSocket(IpEndpointName(ip, port));
    char buffer[1024];
    osc::OutboundPacketStream p(buffer, 1024);
    p << osc::BeginMessage(address) << payload << osc::EndMessage;

    transmitSocket.Send(p.Data(), p.Size());
}

void removeStoredString(int stringId)
{
    for (UINT i = 0; i < storedStrings.size(); i++)
    {
        if (storedStrings[i].id == stringId)
        {
            storedStrings.erase(storedStrings.begin() + i);
            return; //Every ID is unique in the array, no need to keep searching.
        }
    }
}

int addStoredString(std::string theString)
{
    static int storedStringsNextId = 0;

    int storedStringsThisId = storedStringsNextId;
    if (storedStringsNextId == INT_MAX) storedStringsNextId = 0;
    else storedStringsNextId++;

    //Make sure every ID is unique in the array.
    removeStoredString(storedStringsThisId);
    //Limit array size to fixed value
    if (storedStrings.size() >= storedStringsMaxSize) storedStrings.erase(storedStrings.begin());

    storedStrings.push_back(StoredString{ theString, storedStringsThisId });

    return storedStringsThisId;
}

unsigned int getOscType(osc::ReceivedMessage::const_iterator arg)
{
    if (arg->IsBlob()) return OSC_TYPE_BLOB;
    if (arg->IsBool()) return OSC_TYPE_BOOL;
    if (arg->IsChar()) return OSC_TYPE_CHAR;
    if (arg->IsDouble()) return OSC_TYPE_FLOAT64;
    if (arg->IsFloat()) return OSC_TYPE_FLOAT;
    if (arg->IsInt32()) return OSC_TYPE_INT;
    if (arg->IsInt64()) return OSC_TYPE_INT64;
    if (arg->IsRgbaColor()) return OSC_TYPE_COLOR;
    if (arg->IsString()) return OSC_TYPE_STRING;
    if (arg->IsTimeTag()) return OSC_TYPE_TIMETAG;
    return 0;
}

bool isMatchingOscType(unsigned int msgType, unsigned int listenerTypeField)
{
    return (listenerTypeField & msgType);
}

/* Checks if an incoming OSC messages address matches a given pattern.
*  Also handles OSC wildcards! */
bool isMatchingOSCAddress(const char* address, const char* pattern)
{
    //If no wildcards in pattern, do a simple strcmp to save time
    if (!containsOscWildcard(pattern))
    {
        if (strcmp(address, pattern) == 0) return true;
        else return false;
    }

    std::string chars;

    while (*address != '\0' && *pattern != '\0')
    {
        switch (*pattern)
        {
        case '?': //exactly one character
            if (*address == '/') return false; //'?' does not match beyond '/'
            address++;
            pattern++;
            break;
        case '*': //zero or more chars
            pattern++;
            if (isMatchingOSCAddress(address, pattern)) return true; //'*' matches "no char"
            while (*address != '\0' && *address != '/')
            { //shift address one char and check again (recursion)
                address++;
                if (isMatchingOSCAddress(address, pattern)) return true;
            }
            return false;
            break;
        case '[': //Match one character from list (or range of) chars like [asdf] or [a-f] or [!0-9]
            pattern++;
            while (*pattern != '\0' &&
                *pattern != ']' &&
                *pattern != '/')
            {
                if (*pattern == '-') //range of chars
                {
                    pattern++;
                    char c = chars.back() + 1;
                    if (*pattern == ']' || *pattern == '/' || *pattern == '\0') c = *pattern;
                    while (c != *pattern)
                    {
                        chars.push_back(c);
                        c++;
                    }
                }
                chars.push_back(*pattern);
                pattern++;
            }
            if (chars.at(0) == '!') //negated list or range of chars
            {
                chars.erase(chars.begin());
                if (chars.find(*address) != std::string::npos) return false;
            }
            else if (chars.find(*address) == std::string::npos) return false;
            chars.clear();
            if (*pattern == ']') pattern++;
            address++;
            break;
        case '{': //list of strings (comma separated like {asd,fghj,etc}
            bool result;
            result = false;
            pattern++;
            while (!result &&
                *pattern != '\0' &&
                *pattern != '}' &&
                *pattern != '/')
            {
                while (*pattern != '\0' &&
                    *pattern != ',' &&
                    *pattern != '}' &&
                    *pattern != '/')
                {
                    chars.push_back(*pattern);
                    pattern++;
                }
                if (chars.compare(0, chars.length(), address, chars.length()) == 0)
                {
                    result = true;
                    address += chars.length();
                }
                chars.clear(); 
                pattern++;
            }
            if (!result) return false;
            while (*pattern != '\0' &&
                *pattern != '}' &&
                *pattern != '/')
            {
                pattern++;
            }
            if (*pattern == '}') pattern++;
            break;
        default: //Just a character, no wildcard here
            if (*pattern == *address)
            {
                address++;
                pattern++;
            }
            else
            {
                return false;
            }
            break;
        }
    }

    if (*pattern != *address) return false; //Only match if both strings end here.

    return true; //No earlier 'return false' triggered, so we got a match!
}

bool containsOscWildcard(const char* pattern)
{
    while (*pattern != '\0')
    {
        if (*pattern == '?' ||
            *pattern == '*' ||
            *pattern == '[' ||
            *pattern == ']' ||
            *pattern == '{' ||
            *pattern == '}') return true;
        pattern++;
    }
    return false;
}

int handleOscMsg(const osc::ReceivedMessage& m)
{
    int ret = 0;
    unsigned int msgType = 0;

    OutputDebugString(L"handleOscMsg: Address=");
    OutputDebugStringA(m.AddressPattern());
    OutputDebugString(L"\r\n");

    if (!hwnd || !sock->IsBound())
    {
        OutputDebugString(L"handleOscMsg: Seems open() was not called yet...");
        if (!hwnd) OutputDebugString(L" (hwnd)");
        if (!sock->IsBound()) OutputDebugString(L" (sock)");
        OutputDebugString(L"\r\n");
        return -1;
    }

    //Loop through all registered listener entries
    for (UINT i = 0; i < listeners.size(); i++)
    {
        //Check if incoming OSC address matches current listener entry
        if ( isMatchingOSCAddress(m.AddressPattern(), listeners[i].address.c_str()) )
        {
            //Check payload type
            if (m.ArgumentCount() == 0) {
                msgType = OSC_TYPE_NONE;
            }
            else {
                msgType = getOscType(m.ArgumentsBegin());
            }
            if (!msgType) return -1; //Something went wrong

            //Check if listener is valid for received datatype
            if (isMatchingOscType(msgType, listeners[i].dataType)) 
            {
                //Post message depending on message datatype
                if (msgType == OSC_TYPE_NONE) {
                    PostMessage(hwnd, listeners[i].message, OSC_TYPE_NONE, 0);
                    ret++;
                }
                else if (msgType == OSC_TYPE_INT) {
                     PostMessage(hwnd, listeners[i].message, OSC_TYPE_INT, m.ArgumentsBegin()->AsInt32());
                     ret++;
                }
                else if (msgType == OSC_TYPE_FLOAT) {
                    float floatarg = m.ArgumentsBegin()->AsFloat();
                    PostMessage(hwnd, listeners[i].message, OSC_TYPE_FLOAT, reinterpret_cast<int&>(floatarg));
                    ret++;
                }
                else if (msgType == OSC_TYPE_INT64) {
                    PostMessage(hwnd, listeners[i].message, OSC_TYPE_INT, m.ArgumentsBegin()->AsInt64());
                    ret++;
                }
                else if (msgType == OSC_TYPE_FLOAT64) {
                    double doublearg = m.ArgumentsBegin()->AsDouble();
                    PostMessage(hwnd, listeners[i].message, OSC_TYPE_FLOAT, reinterpret_cast<int&>(doublearg));
                    ret++;
                }
                else if (msgType == OSC_TYPE_BOOL) {
                    PostMessage(hwnd, listeners[i].message, OSC_TYPE_FLOAT, m.ArgumentsBegin()->AsBool());
                    ret++;
                }
                else if (msgType == OSC_TYPE_CHAR) {
                    PostMessage(hwnd, listeners[i].message, OSC_TYPE_FLOAT, m.ArgumentsBegin()->AsChar());
                    ret++;
                }
                else if (msgType == OSC_TYPE_COLOR) {
                    PostMessage(hwnd, listeners[i].message, OSC_TYPE_FLOAT, m.ArgumentsBegin()->AsRgbaColor());
                    ret++;
                }
                else if (msgType == OSC_TYPE_TIMETAG) {
                    uint64_t timearg = m.ArgumentsBegin()->AsTimeTag();
                    PostMessage(hwnd, listeners[i].message, OSC_TYPE_FLOAT, reinterpret_cast<int&>(timearg));
                    ret++;
                }
                else if (msgType == OSC_TYPE_STRING) {
                    PostMessage(hwnd, listeners[i].message, 
                        OSC_TYPE_STRING, 
                        addStoredString( std::string(m.ArgumentsBegin()->AsString()) ) ) ;
                }
                else if (msgType == OSC_TYPE_BLOB) {
                    OutputDebugString(L"handleOScMsg: Blob not implemented yet"); //TODO
                }
                else
                    OutputDebugString(L"handleOscMsg: Unknown datatype\r\n");
            }
        }
    }

    if (ret > 0) OutputDebugString(L"handleOscMsg: Found and posted at least once.\r\n");

    return ret;
}

#ifdef _DEBUG
/* Debugging function to test messaging. Probably will be removed later. */
DLLEXPORT int testMsg(HWND windowHandle, unsigned int messageID)
{
    float theFloat = 1.01;
    int lParam = reinterpret_cast<int&>(theFloat);

    PostMessage(hwnd, 0x1002, 0, lParam); //post to message queue
    return reinterpret_cast<int&>(theFloat);
}
#endif // DEBUG

