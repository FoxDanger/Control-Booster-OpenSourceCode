#pragma once

#include <windows.h>
#include <string>
#include <osc/OscReceivedElements.h>

#define DLLEXPORT __declspec(dllexport)

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
#define OSC_TYPE_ALL		UINT_MAX

extern "C" DLLEXPORT int open(HWND targetWindowHandle, unsigned int port);
extern "C" DLLEXPORT int close(unsigned int clearListeners = 1);
extern "C" DLLEXPORT int addListener(LPCSTR address, unsigned int messageID, unsigned int dataType = OSC_TYPE_ALL);
extern "C" DLLEXPORT int removeListener(LPCSTR address);
extern "C" DLLEXPORT char* getStringData(char* targetString, unsigned int targetSize, unsigned int StringID);
extern "C" DLLEXPORT void sendOscMessageInt(char* ip, unsigned int port, char* address, int payload);
extern "C" DLLEXPORT void sendOscMessageInt2(char* ip, unsigned int port, char* address, int payload1, int payload2);
extern "C" DLLEXPORT void sendOscMessageFloat(char* ip, unsigned int port, char* address, float payload);
extern "C" DLLEXPORT void sendOscMessageFloat2(char* ip, unsigned int port, char* address, float payload1, float payload2);
extern "C" DLLEXPORT void sendOscMessageString(char* ip, unsigned int port, char* address, char* payload);
extern "C" DLLEXPORT void sendOscMessageString2(char* ip, unsigned int port, char* address, char* payload1, char* payload2);
int handleOscMsg(const osc::ReceivedMessage& m);
bool isMatchingOscType(unsigned int msgType, unsigned int listenerTypeField);
bool isMatchingOSCAddress(const char* address, const char* pattern);
bool containsOscWildcard(const char* pattern);
unsigned int getOscType(osc::ReceivedMessage::const_iterator arg);
void removeStoredString(int stringId);
int addStoredString(std::string theString);
#ifdef _DEBUG
extern "C" DLLEXPORT int testMsg(HWND windowHandle, unsigned int messageID);
#endif
