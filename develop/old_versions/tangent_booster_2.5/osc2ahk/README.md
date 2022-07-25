## OSC2AHK

This is a DLL extension for [AutoHotkey](https://www.autohotkey.com/) that enables support for OSC (Open Sound Control).

## Table of contents

- [OSC2AHK](#osc2ahk)
- [Work in progress](#work-in-progress)
- [Table of contents](#table-of-contents)
- [Installation](#installation)
- [Usage](#usage)
  - [General concept](#general-concept)
  - [Receive functions](#receive-functions)
    - [Load DLL](#load-dll)
    - [Open network port](#open-network-port)
    - [Close network port](#close-network-port)
    - [Add listener](#add-listener)
    - [Remove listener](#remove-listener)
    - [Get string data](#get-string-data)
  - [Send functions](#send-functions)
    - [Send integer message](#send-integer-message)
    - [Send float message](#send-float-message)
    - [Send string message](#send-string-message)
- [Credits](#credits)

## Installation
Just download the latest version of OSC2AHK.dll from the [releases page](https://files.eleton-audio.de/gitea/Ludwig/OSC2AHK/releases) and place it in the same directory as your AutoHotkey scripts. Maybe you also want to check out the provided [usage examples](https://files.eleton-audio.de/gitea/Ludwig/OSC2AHK/src/branch/master/examples).

## Usage
### General concept
After the DLL is loaded and a network port is opened with the [`open()`](https://files.eleton-audio.de/gitea/Ludwig/OSC2AHK#open-network-port) function, it receives all incoming OSC messages. To specify the messages that should be passed to the AutoHotkey (AHK) script, "listeners" are specified and created by the ['addListener()'](https://files.eleton-audio.de/gitea/Ludwig/OSC2AHK#add-listener) function. When a OSC message is received that matches a existing listener, a "system message" is sent to the AHK script. This happens via the Windows message queue and the system message ID is used to tell the script which OSC address was received. Therefore with [`addListener()`](https://files.eleton-audio.de/gitea/Ludwig/OSC2AHK#add-listener) a ID has to be passed to the DLL which then uses this ID to post the system message.

### Receive functions
These functions are the main functions used to receive OSC messages in AHK.
#### Load DLL
First the DLL should be loaded from within the AHK script by calling
```
DllCall("LoadLibrary", "Str", "OSC2AHK.dll", "Ptr")
```
(Assuming the OSC2AHK.dll file is in the same directory as the calling script.)

#### Open network port
```cpp
int open(HWND targetWindowHandle, unsigned int port);
//targetWindowHandle: Handle to the calling window to which messages on received OSC data is sent
//port: Network port to open
//returns: Zero on success, something else on failure
```
This opens the network port and enables the DLL to receive OSC messages.

Example AHK snippet:
```
Gui +LastFound
hWnd := WinExist()
success := DllCall("OSC2AHK.dll\open", UInt, hWnd, UInt, 7002)
if (success != 0)
    msgbox, Failed to open port!
```

#### Close network port
If you want to close the network port before termination of the script you may use:
```cpp
int close(unsigned int clearListeners = 1);
//clearListeners: If this is not zero, all the listeners will also be removed (for future open() call). May be omitted, then defaults to 1 (remove listeners).
```
Example AHK call without clearing the listners:
```
DllCall("OSC2AHK.dll\close", UInt, 0)
```

#### Add listener
```cpp
int addListener(LPCSTR address, unsigned int messageID, unsigned int dataType = OSC_TYPE_ALL);
//address: OSC address to listen for
//messageID: ID for the system message that is sent to the AHK script when this listener receives something.
//dataType: Specifies the OSC datatype to listen for. See below. May be omitted, then it defaults to all datatypes.
```
This adds a new listener for a OSC address pattern, only OSC messages with a existing listener will be passed to the calling script. The (system) message ID may be in the range 0x0400 (the value of WM_USER) through 0x7FFF for general purpose use but others can be used for special purposes as well (maybe see [Microsoft's page about messages](https://docs.microsoft.com/en-us/windows/win32/winmsg/about-messages-and-message-queues#application-defined-messages)). Only if the address and the datatype of a incoming OSC message match the ones of the listeners, a message is posted to the AHK script. Note that the datatype can be one of the following values or the sum of multiple ones.
```cpp
#define OSC_TYPE_NONE		1
#define OSC_TYPE_INT		2
#define OSC_TYPE_FLOAT		4
#define OSC_TYPE_STRING		8
#define OSC_TYPE_BLOB		16
#define OSC_TYPE_INT64		32
#define OSC_TYPE_FLOAT64	64
#define OSC_TYPE_BOOL		128
#define OSC_TYPE_CHAR		256
#define OSC_TYPE_TIMETAG	512
#define OSC_TYPE_COLOR		1024
#define OSC_TYPE_ALL		UINT_MAX //=0xffffffff
```
Add a listener from the AHK script:
```
; just for convenience, you also could use the "magic numbers" directly
global oscTypeInt := 2
global oscTypeFloat := 4
; Tell the DLL to post a system message with ID 0x1001 when a OSC message with address "/test1" and type Integer or Float is received.
DllCall("OSC2AHK.dll\addListener", AStr, "/test1", UInt, 0x1001, UInt, oscTypeInt+oscTypeFloat)
; tell AHK to invoke the function msghandlerTest1 when a windows message with ID 0x1001 is received
OnMessage(0x1001, "msghandlerTest1")
```
Then, there has to be the handler function in the AHK script:
```
msghandlerTest1(oscType, data, msgID, hwnd) 
{
    ; Check which datatype we received
    if (oscType = oscTypeInt) 
    {
        ; Integers can be used "as is"
        msgbox,Got Integer: %data%
    }
    if (oscType = oscTypeFloat) 
    {
        ; Floats have to be "reinterpreted"
        VarSetCapacity(buf, 4, 0)
        NumPut(data, buf)
        theFloat := NumGet(buf, "Float")
        msgbox,Got Float: %theFloat%
    }
}
```
Note that you may add many listeners, for any combination of the same/different OSC addresses, datatypes and system message IDs. Also, in AutoHotkey you may add multiple callback functions for the same system message ID or multiple system message IDs to the same callback function. This creates a big flexibility but to keep it less clutterd, such multiple routing paths should be avoided where possible.

For advanced usage, the address pattern passed to `addListener()` supports standard OSC wildcards, so one listener can match multiple messages that share some simliarities. These wildcards are supported by the OSC 1.0 standard:

> * '?' in the OSC Address Pattern matches any single character
> * '*' in the OSC Address Pattern matches any sequence of zero or more characters
> * A string of characters in square brackets (e.g., "[string]") in the OSC Address Pattern matches any character in the string. Inside square brackets, the minus sign (-) and exclamation point (!) have special meanings:
>     * two characters separated by a minus sign indicate the range of characters between the given two in ASCII collating sequence. (A minus sign at the end of the string has no special meaning.)
>     * An exclamation point at the beginning of a bracketed string negates the sense of the list, meaning that the list matches any character not in the list. (An exclamation point anywhere besides the first character after the open bracket has no special meaning.)
> * A comma-separated list of strings enclosed in curly braces (e.g., "{foo,bar}") in the OSC Address Pattern matches any of the strings in the list.
> * Any other character in an OSC Address Pattern can match only the same character.
>
>  -- <cite>[http://opensoundcontrol.org/]</cite>

#### Remove listener
Of course, listeners also can be removed in a similar way:
```cpp
int removeListener(LPCSTR address);
```
Example AHK call:
```
DllCall("OSC2AHK.dll\removeListener", AStr, "/test1")
```

#### Get string data
As string data carried by OSC messages may be of varying length and cannot directly be passed by system messages. Therefore, the string is buffered in the DLL and the `data` variable of the callback function receives a unique identifier to the stored string. This string then can be retrieved later on from the AHK script by calling this function.
```cpp
char* getStringData(char* targetString, unsigned int targetSize, unsigned int StringID);
```
This function writes the stored string to the `targetString` and also removes it from the buffer inside the DLL.

A callback functin in AHK could look like this (also look at the [string example](https://files.eleton-audio.de/gitea/Ludwig/OSC2AHK/src/branch/master/examples/string_example.ahk)):
```
msghandlerString(oscType, data, msgID, hwnd) 
{
    VarSetCapacity(theString, 20)
    theString := DllCall("OSC2AHK.dll\getStringData", str, theString, UInt, 20, UInt, data, AStr)

    msgbox,Got string: %theString%
}
```

### Send functions
The DLL also can be used to transmit OSC messages from AutoHotkey by using the following functions. Usually there is only one argument (payload) per message, but the functions ending in "...2" allow the sending of two arguments in one message. Only two arguments of the same type are supported at the moment.

#### Send integer message
```cpp
void sendOscMessageInt(char* ip, unsigned int port, char* address, int payload);
void sendOscMessageInt2(char* ip, unsigned int port, char* address, int payload1, int payload2);
```
Example call from AHK:
```
ip := "192.168.1.2"
port := 8002
addr := "/testmsg"
data := 42
DllCall("OSC2AHK.dll\sendOscMessageInt", AStr, ip, UInt, port, AStr, addr, Int, data)
```

#### Send float message
```cpp
void sendOscMessageFloat(char* ip, unsigned int port, char* address, float payload);
void sendOscMessageFloat2(char* ip, unsigned int port, char* address, float payload1, float payload2);
```
Example call from AHK:
```
ip := "192.168.1.2"
port := 8002
addr := "/my/msg"
data := 42.3
DllCall("OSC2AHK.dll\sendOscMessageFloat", AStr, ip, UInt, port, AStr, addr, Float, data)
```

#### Send string message
```cpp
void sendOscMessageString(char* ip, unsigned int port, char* address, char* payload);
void sendOscMessageString2(char* ip, unsigned int port, char* address, char* payload1, char* payload2);
```
Example call from AHK:
```
ip := "192.168.1.2"
port := 8002
addr := "/some/message"
data := "This is the string"
DllCall("OSC2AHK.dll\sendOscMessageString", AStr, ip, UInt, port, AStr, addr, AStr, data)
```

## Credits
This DLL uses the [oscpack](http://www.rossbencina.com/code/oscpack) OSC implementation by Ross Bencina.