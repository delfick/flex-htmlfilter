#include <windows.h>
#include <shellapi.h>

int WINAPI 
WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow )
{
	ShellExecute( NULL, "open", lpCmdLine, NULL, NULL, SW_SHOWNORMAL );
	return 0;
}
