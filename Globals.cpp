/* DIME IME for Windows 7/8/10/11

BSD 3-Clause License

Copyright (c) 2022, Jeremy Wu
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <map>
#include "Globals.h"
#include "Private.h"
#include "resource.h"
#include "BaseWindow.h"
#include "define.h"
#include "BaseStructure.h"


namespace Global {


BOOL isWindows8 = FALSE;

IME_MODE imeMode = IME_MODE::IME_MODE_NONE;

BOOL hasPhraseSection = FALSE;
BOOL hasCINPhraseSection = FALSE;

HFONT defaultlFontHandle;				// Global font object we use everywhere


//---------------------------------------------------------------------
// Unicode byte order mark
//---------------------------------------------------------------------
extern const WCHAR UnicodeByteOrderMark = 0xFEFF;

//---------------------------------------------------------------------
// dictionary table delimiter
//---------------------------------------------------------------------
extern WCHAR KeywordDelimiter = L'=';
extern const WCHAR StringDelimiter = L'\"';
//---------------------------------------------------------------------
// DIME CLSID
//---------------------------------------------------------------------
// {0ECD73D8-4DC8-4DEC-98F6-DE7271205E43}
extern const CLSID DIMECLSID =
{ 0x0ecd73d8, 0x4dc8, 0x4dec, { 0x98, 0xf6, 0xde, 0x72, 0x71, 0x20, 0x5e, 0x43 } };



//---------------------------------------------------------------------
// TSFDayiProfile GUID
//---------------------------------------------------------------------
// {B38581B4-272B-4CF9-85BA-2A944C7F888D}
extern const GUID DIMEDayiGuidProfile =
{ 0xb38581b4, 0x272b, 0x4cf9, { 0x85, 0xba, 0x2a, 0x94, 0x4c, 0x7f, 0x88, 0x8d } };
//---------------------------------------------------------------------
// TSFArrayProfile GUID
//---------------------------------------------------------------------
// {5DFC1743-638C-4F61-9E76-FCFA9707F450}
extern const GUID DIMEArrayGuidProfile =
{ 0x5dfc1743, 0x638c, 0x4f61, { 0x9e, 0x76, 0xfc, 0xfa, 0x97, 0x7, 0xf4, 0x50 } };
//---------------------------------------------------------------------
// TSFPhoneticProfile GUID
//---------------------------------------------------------------------
// {BEAADE4E-E17E-4081-9163-8199DDB3612E}
extern const GUID DIMEPhoneticGuidProfile =
{ 0xbeaade4e, 0xe17e, 0x4081, { 0x91, 0x63, 0x81, 0x99, 0xdd, 0xb3, 0x61, 0x2e } };
//---------------------------------------------------------------------
// TSFGenericProfile GUID
//---------------------------------------------------------------------
// {ED837653-3314-4A43-8C84-CC7AE239F4FC}
extern const GUID DIMEGenericGuidProfile =
{ 0xed837653, 0x3314, 0x4a43, { 0x8c, 0x84, 0xcc, 0x7a, 0xe2, 0x39, 0xf4, 0xfc } };

#ifndef DIMESettings
_T_GetDpiForMonitor _GetDpiForMonitor = nullptr;
HINSTANCE hShcore = NULL;
HINSTANCE dllInstanceHandle;

LONG dllRefCount = -1;
CRITICAL_SECTION CS;

//---------------------------------------------------------------------
// PreserveKey GUID
//---------------------------------------------------------------------
// {0FC8C82C-4D31-41C8-9E72-450A026271B3}
extern const GUID DIMEGuidImeModePreserveKey = 
{ 0x0fc8c82c, 0x4d31, 0x41c8, { 0x9e, 0x72, 0x45, 0xa, 0x2, 0x62, 0x71, 0xb3 } };

// {701652B2-389D-430A-B779-1F0C28901EA6}
extern const GUID DIMEGuidDoubleSingleBytePreserveKey = 
{ 0x701652b2, 0x389d, 0x430a, { 0xb7, 0x79, 0x1f, 0x0c, 0x28, 0x90, 0x1e, 0xa6 } };

// {CB42C2D9-BF6E-465B-B8EE-11A1DE906359}
extern const GUID DIMEGuidConfigPreserveKey = 
{ 0xcb42c2d9, 0xbf6e, 0x465b, { 0xb8, 0xee, 0x11, 0xa1, 0xde, 0x90, 0x63, 0x59 } };

//---------------------------------------------------------------------
// Compartments
//---------------------------------------------------------------------
// {5D0AB980-0DBB-4884-B813-2E5D26B96577}
extern const GUID DIMEGuidCompartmentIMEMode = 
{ 0x5d0ab980, 0x0dbb, 0x4884, { 0xb8, 0x13, 0x2e, 0x5d, 0x26, 0xb9, 0x65, 0x77 } };
// {2EC32577-CF56-48E5-A4A0-5A63FB93CEC3}
extern const GUID DIMEGuidCompartmentDoubleSingleByte = 
{ 0x2ec32577, 0xcf56, 0x48e5, { 0xa4, 0xa0, 0x5a, 0x63, 0xfb, 0x93, 0xce, 0xc3 } };


//---------------------------------------------------------------------
// LanguageBars
//---------------------------------------------------------------------


// {887C3B51-0270-437C-818D-B8644146AE87}
extern const GUID DIMEGuidLangBarIMEMode = 
{ 0x887c3b51, 0x0270, 0x437c, { 0x81, 0x8d, 0xb8, 0x64, 0x41, 0x46, 0xae, 0x87 } };

// {BFC0FB38-1AF8-404B-B15A-48518D8FA17F}
extern const GUID DIMEGuidLangBarDoubleSingleByte = 
{ 0xbfc0fb38, 0x1af8, 0x404b, { 0xb1, 0x5a, 0x48, 0x51, 0x8d, 0x8f, 0xa1, 0x7f } };

// {10DC1D31-2DFA-4FEE-AEFD-BB46D804F705}
extern const GUID DIMEGuidDisplayAttributeInput = 
{ 0x10dc1d31, 0x2dfa, 0x4fee, { 0xae, 0xfd, 0xbb, 0x46, 0xd8, 0x4, 0xf7, 0x5 } };

// {3AE145B1-7163-4C66-AE5A-71465175484D}
extern const GUID DIMEGuidDisplayAttributeConverted = 
{ 0x3ae145b1, 0x7163, 0x4c66, { 0xae, 0x5a, 0x71, 0x46, 0x51, 0x75, 0x48, 0x4d } };


//---------------------------------------------------------------------
// UI element
//---------------------------------------------------------------------

// {2887076F-7B9A-463B-BB2F-9BD67400FEA5}
extern const GUID DIMEGuidCandUIElement = 
{ 0x2887076f, 0x7b9a, 0x463b, { 0xbb, 0x2f, 0x9b, 0xd6, 0x74, 0x0, 0xfe, 0xa5 } };

//---------------------------------------------------------------------
// defined item in setting file table [PreservedKey] section
//---------------------------------------------------------------------


extern WCHAR ImeModeDescription[50] = {'\0'};
extern const int ImeModeOnIcoIndex = IME_MODE_ON_ICON_INDEX;
extern const int ImeModeOffIcoIndex = IME_MODE_OFF_ICON_INDEX;

extern WCHAR DoubleSingleByteDescription[50] = {'\0'};
extern const int DoubleSingleByteOnIcoIndex = IME_DOUBLE_ON_INDEX;
extern const int DoubleSingleByteOffIcoIndex = IME_DOUBLE_OFF_INDEX;


//---------------------------------------------------------------------
// defined item in setting file table [LanguageBar] section
//---------------------------------------------------------------------
extern const WCHAR LangbarImeModeDescription[] = L"Conversion mode";
extern const WCHAR LangbarDoubleSingleByteDescription[] = L"Character width";


//---------------------------------------------------------------------
// windows class / titile / atom
//---------------------------------------------------------------------
extern const WCHAR CandidateClassName[] = L"CJ2356.CandidateWindow";
ATOM AtomCandidateWindow;
extern const WCHAR CandidateShadowClassName[] = L"CJ2356.CandidateShadowWindow";
ATOM AtomCandidateShadowWindow;
extern const WCHAR CandidateScrollBarClassName[] = L"CJ2356.CandidateScrollBarWindow";
ATOM AtomCandidateScrollBarWindow;
extern const WCHAR NotifyClassName[] = L"CJ2356.NotifyWindow";
ATOM AtomNotifyWindow;
extern const WCHAR NotifyShadowClassName[] = L"CJ2356.NotifyShadowWindow";
ATOM AtomNotifyShadowWindow;


BOOL RegisterWindowClass()
{
    if (!CBaseWindow::_InitWindowClass(CandidateClassName, &AtomCandidateWindow))
    {
        return FALSE;
    }
    if (!CBaseWindow::_InitWindowClass(CandidateShadowClassName, &AtomCandidateShadowWindow))
    {
        return FALSE;
    }
    if (!CBaseWindow::_InitWindowClass(CandidateScrollBarClassName, &AtomCandidateScrollBarWindow))
    {
        return FALSE;
    }
	
    if (!CBaseWindow::_InitWindowClass(NotifyClassName, &AtomNotifyWindow))
    {
        return FALSE;
    }
    if (!CBaseWindow::_InitWindowClass(NotifyShadowClassName, &AtomNotifyShadowWindow))
    {
        return FALSE;
    }

    return TRUE;
}

//---------------------------------------------------------------------
// defined full width characters for Double/Single byte conversion
//---------------------------------------------------------------------
extern const WCHAR FullWidthCharTable[] = {
    //         !       "       #       $       %       &       '       (    )       *       +       ,       -       .       /
    0x3000, 0xFF01, 0xFF02, 0xFF03, 0xFF04, 0xFF05, 0xFF06, 0xFF07, 0xFF08, 0xFF09, 0xFF0A, 0xFF0B, 0xFF0C, 0xFF0D, 0xFF0E, 0xFF0F,
    // 0       1       2       3       4       5       6       7       8       9       :       ;       <       =       >       ?
    0xFF10, 0xFF11, 0xFF12, 0xFF13, 0xFF14, 0xFF15, 0xFF16, 0xFF17, 0xFF18, 0xFF19, 0xFF1A, 0xFF1B, 0xFF1C, 0xFF1D, 0xFF1E, 0xFF1F,
    // @       A       B       C       D       E       F       G       H       I       J       K       L       M       N       0
    0xFF20, 0xFF21, 0xFF22, 0xFF23, 0xFF24, 0xFF25, 0xFF26, 0xFF27, 0xFF28, 0xFF29, 0xFF2A, 0xFF2B, 0xFF2C, 0xFF2D, 0xFF2E, 0xFF2F,
    // P       Q       R       S       T       U       V       W       X       Y       Z       [       \       ]       ^       _
    0xFF30, 0xFF31, 0xFF32, 0xFF33, 0xFF34, 0xFF35, 0xFF36, 0xFF37, 0xFF38, 0xFF39, 0xFF3A, 0xFF3B, 0xFF3C, 0xFF3D, 0xFF3E, 0xFF3F,
    // '       a       b       c       d       e       f       g       h       i       j       k       l       m       n       o       
    0xFF40, 0xFF41, 0xFF42, 0xFF43, 0xFF44, 0xFF45, 0xFF46, 0xFF47, 0xFF48, 0xFF49, 0xFF4A, 0xFF4B, 0xFF4C, 0xFF4D, 0xFF4E, 0xFF4F,
    // p       q       r       s       t       u       v       w       x       y       z       {       |       }       ~
    0xFF50, 0xFF51, 0xFF52, 0xFF53, 0xFF54, 0xFF55, 0xFF56, 0xFF57, 0xFF58, 0xFF59, 0xFF5A, 0xFF5B, 0xFF5C, 0xFF5D, 0xFF5E
};

//---------------------------------------------------------------------
// defined symbol characters
//---------------------------------------------------------------------
extern const WCHAR DayiSymbolCharTable[] = L" !\\\"#$%&\'()*+,-./0123456789:;<>?@[]^_`{}|~";
//---------------------------------------------------------------------
// defined directly input address characters
//---------------------------------------------------------------------
extern const _DAYI_ADDRESS_DIRECT_INPUT dayiAddressCharTable[12] = {
	{ L',', L'，' },        //快速鍵
	{L'.', L'。'},
    { L'!', L'！' },
    { L'?', L'？' },
    { L'(', L'（' },
    { L')', L'）' },
    { L'\\', L'、' },
    { L';', L'；' },
    { L':', L'：' },
    { L'_', L'—' },
    { L'=', L'=' },
    { L'~', L'～' }
};
//---------------------------------------------------------------------
// defined directly input full shaped symbols in article modes
//---------------------------------------------------------------------
extern const _DAYI_ADDRESS_DIRECT_INPUT dayiArticleCharTable[12] = {
	{ L',', L'，' },
	{ L'.', L'。' },
    { L'!', L'！' },
    { L'?', L'？' },
    { L'(', L'（' },
    { L')', L'）' },
    { L'\\', L'、' },
    { L';', L'；' },
    { L':', L'：' },
    { L'_', L'—' },
    { L'=', L'=' },
    { L'~', L'～' }

	//{ L'[', L'' },
	//{ L']', L'' },
	//{ L'-', L'' },
	//{ L'\\', L'' }
};


//+---------------------------------------------------------------------------
//
// CheckModifiers
//
//----------------------------------------------------------------------------

#define TF_MOD_ALLALT     (TF_MOD_RALT | TF_MOD_LALT | TF_MOD_ALT)
#define TF_MOD_ALLCONTROL (TF_MOD_RCONTROL | TF_MOD_LCONTROL | TF_MOD_CONTROL)
#define TF_MOD_ALLSHIFT   (TF_MOD_RSHIFT | TF_MOD_LSHIFT | TF_MOD_SHIFT)
#define TF_MOD_RLALT      (TF_MOD_RALT | TF_MOD_LALT)
#define TF_MOD_RLCONTROL  (TF_MOD_RCONTROL | TF_MOD_LCONTROL)
#define TF_MOD_RLSHIFT    (TF_MOD_RSHIFT | TF_MOD_LSHIFT)

#define CheckMod(m0, m1, mod)        \
    if (m1 & TF_MOD_ ## mod ##)      \
{ \
    if (!(m0 & TF_MOD_ ## mod ##)) \
{      \
    return FALSE;   \
}      \
} \
    else       \
{ \
    if ((m1 ^ m0) & TF_MOD_RL ## mod ##)    \
{      \
    return FALSE;   \
}      \
} \



BOOL CheckModifiers(UINT modCurrent, UINT mod)
{
    mod &= ~TF_MOD_ON_KEYUP;

    if (mod & TF_MOD_IGNORE_ALL_MODIFIER)
    {
        return TRUE;
    }

    if (modCurrent == mod)
    {
        return TRUE;
    }

    if (modCurrent && !mod)
    {
        return FALSE;
    }

    CheckMod(modCurrent, mod, ALT);
    CheckMod(modCurrent, mod, SHIFT);
    CheckMod(modCurrent, mod, CONTROL);

    return TRUE;
}

//+---------------------------------------------------------------------------
//
// UpdateModifiers
//
//    wParam - virtual-key code
//    lParam - [0-15]  Repeat count
//  [16-23] Scan code
//  [24]    Extended key
//  [25-28] Reserved
//  [29]    Context code
//  [30]    Previous key state
//  [31]    Transition state
//----------------------------------------------------------------------------

USHORT ModifiersValue = 0;
BOOL   IsShiftKeyDownOnly = FALSE;
BOOL   IsControlKeyDownOnly = FALSE;
BOOL   IsAltKeyDownOnly = FALSE;

BOOL UpdateModifiers(WPARAM wParam, LPARAM lParam)
{
    // high-order bit : key down
    // low-order bit  : toggled
    SHORT sksMenu = GetKeyState(VK_MENU);
    SHORT sksCtrl = GetKeyState(VK_CONTROL);
    SHORT sksShft = GetKeyState(VK_SHIFT);

    switch (wParam & 0xff)
    {
    case VK_MENU:
        // is VK_MENU down?
        if (sksMenu & 0x8000)
        {
            // is extended key?
            if (lParam & 0x01000000)
            {
                ModifiersValue |= (TF_MOD_RALT | TF_MOD_ALT);
            }
            else
            {
                ModifiersValue |= (TF_MOD_LALT | TF_MOD_ALT);
            }

            // is previous key state up?
            if (!(lParam & 0x40000000))
            {
                // is VK_CONTROL and VK_SHIFT up?
                if (!(sksCtrl & 0x8000) && !(sksShft & 0x8000))
                {
                    IsAltKeyDownOnly = TRUE;
                }
                else
                {
                    IsShiftKeyDownOnly = FALSE;
                    IsControlKeyDownOnly = FALSE;
                    IsAltKeyDownOnly = FALSE;
                }
            }
        }
        break;

    case VK_CONTROL:
        // is VK_CONTROL down?
        if (sksCtrl & 0x8000)    
        {
            // is extended key?
            if (lParam & 0x01000000)
            {
                ModifiersValue |= (TF_MOD_RCONTROL | TF_MOD_CONTROL);
				ModifiersValue &= TF_MOD_LCONTROL;
            }
            else
            {
                ModifiersValue |= (TF_MOD_LCONTROL | TF_MOD_CONTROL);
				ModifiersValue &= TF_MOD_RCONTROL;
            }

            // is previous key state up?
            if (!(lParam & 0x40000000))
            {
                // is VK_SHIFT and VK_MENU up?
                if (!(sksShft & 0x8000) && !(sksMenu & 0x8000))
                {
                    IsControlKeyDownOnly = TRUE;
                }
                else
                {
                    IsShiftKeyDownOnly = FALSE;
                    IsControlKeyDownOnly = FALSE;
                    IsAltKeyDownOnly = FALSE;
                }
            }
        }
        break;

    case VK_SHIFT:
        // is VK_SHIFT down?
        if (sksShft & 0x8000)    
        {
            // is scan code 0x36(right shift)?
            if (((lParam >> 16) & 0x00ff) == 0x36)
            {
                ModifiersValue |= (TF_MOD_RSHIFT | TF_MOD_SHIFT);
				ModifiersValue &= ~TF_MOD_LSHIFT;
            }
            else
            {
                ModifiersValue |= (TF_MOD_LSHIFT | TF_MOD_SHIFT);
				ModifiersValue &= ~TF_MOD_RSHIFT;
            }

            // is previous key state up?
            if (!(lParam & 0x40000000))
            {
                // is VK_MENU and VK_CONTROL up?
                if (!(sksMenu & 0x8000) && !(sksCtrl & 0x8000))
                {
                    IsShiftKeyDownOnly = TRUE;
                }
                else
                {
                    IsShiftKeyDownOnly = FALSE;
                    IsControlKeyDownOnly = FALSE;
                    IsAltKeyDownOnly = FALSE;
                }
            }
        }
        break;

    default:
        IsShiftKeyDownOnly = FALSE;
        IsControlKeyDownOnly = FALSE;
        IsAltKeyDownOnly = FALSE;
        break;
    }

    if (!(sksMenu & 0x8000))
    {
        ModifiersValue &= ~TF_MOD_ALLALT;
    }
    if (!(sksCtrl & 0x8000))
    {
        ModifiersValue &= ~TF_MOD_ALLCONTROL;
    }
    if (!(sksShft & 0x8000))
    {
        ModifiersValue &= ~TF_MOD_ALLSHIFT;
    }

    return TRUE;
}

//---------------------------------------------------------------------
// override CompareElements
//---------------------------------------------------------------------
BOOL CompareElements(LCID locale, const CStringRange* pElement1, const CStringRange* pElement2)
{
    return (CStringRange::Compare(locale, (CStringRange*)pElement1, (CStringRange*)pElement2) == CSTR_EQUAL) ? TRUE : FALSE;
}
#endif

}