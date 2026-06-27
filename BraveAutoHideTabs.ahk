#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; ⚙️ CONFIGURATION
; ==============================================================================
revealZone    := 6        ; Mysz ODSŁANIA karty, gdy jest wyżej niż ta linia (px od góry)
keepAliveH    := 95       ; HISTEREZA: Mysz UTRZYMUJE widoczność, dopóki nie zjedzie poniżej tej linii
overlayH      := 84       ; Wysokość czarnej belki (zależy od Twojego interfejsu, np. 76-84 px)
pollMs        := 35       ; Odświeżanie pętli (responsywność)

targetExe     := "brave.exe"
themeColor    := "1E1E1E" ; Dopasuj do tła Brave, unikaj czystego #000000

; ==============================================================================
; 🎨 INIT & OVERLAY SETUP
; ==============================================================================
; KRYTYCZNE (z wersji B): Czytamy pozycję myszy względem krawędzi okna, a nie całego monitora
CoordMode("Mouse", "Client") 

; Flaga +E0x20 sprawia, że okno "przepuszcza" kliknięcia myszy do przeglądarki
overlay := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
overlay.BackColor := themeColor

; KRYTYCZNE (z wersji A): Delikatna przezroczystość, by belka wtapiała się w jasne strony (0-255)
WinSetTransparent(248, overlay.Hwnd)

isOverlayShown := false
scriptEnabled  := true

; ==============================================================================
; ⌨️ HOTKEYS
; ==============================================================================
^!h::ToggleEngine()   ; Ctrl+Alt+H -> włącz/wyłącz autoukrywanie
^!q::ExitApp()        ; Ctrl+Alt+Q -> awaryjne wyjście

; ==============================================================================
; 🧠 MAIN LOGIC (STATE MACHINE)
; ==============================================================================
SetTimer(LogicLoop, pollMs)

LogicLoop() {
    global isOverlayShown, scriptEnabled, targetExe
    global revealZone, keepAliveH, overlayH

    if (!scriptEnabled)
        return

    ; 1. Czy Brave jest aktywny? Jeśli klikniesz WinMenu albo inne okno, wyłączamy belkę.
    if !WinActive("ahk_exe " targetExe) {
        HideBox()
        return
    }

    ; 2. DETEKCJA FULLSCREEN (np. YouTube, F11)
    ; (Genialny fix z wersji B): Okno pełnoekranowe traci styl WS_CAPTION (0x00C00000).
    try {
        if !(WinGetStyle("A") & 0x00C00000) { 
            HideBox()
            return
        }
    } catch {
        return
    }

    MouseGetPos(&mX, &mY)

    ; 3. MASZYNA STANÓW Z HISTEREZĄ
    if (isOverlayShown) {
        ; STAN A: Karty są zasłonięte. Czekamy, aż uderzysz myszką w "sufit".
        if (mY <= revealZone && mY >= 0) {
            HideBox()
        }
        else {
            ; Zabezpieczenie (z wersji A): Odświeżanie pozycji, jeśli przesuniesz okno Brave na inny monitor!
            UpdateBoxPosition() 
        }
    } else {
        ; STAN B: Karty są widoczne. Czekamy, aż odjedziesz myszką dostatecznie nisko.
        if (mY > keepAliveH) {
            ShowBox()
        }
    }
}

; ==============================================================================
; 🛠️ ACTIONS & HELPERS
; ==============================================================================
ShowBox() {
    global overlay, isOverlayShown, overlayH
    if (!isOverlayShown) {
        ; WinGetClientPos pomija niewidzialne cienie DWM (Fix z wersji B)
        WinGetClientPos(&cX, &cY, &cW, &cH, "A")
        overlay.Show("x" cX " y" cY " w" cW " h" overlayH " NoActivate")
        isOverlayShown := true
    }
}

UpdateBoxPosition() {
    global overlay, isOverlayShown, overlayH
    if (isOverlayShown) {
        WinGetClientPos(&cX, &cY, &cW, &cH, "A")
        overlay.Move(cX, cY, cW, overlayH)
    }
}

HideBox() {
    global overlay, isOverlayShown
    if (isOverlayShown) {
        overlay.Hide()
        isOverlayShown := false
    }
}

ToggleEngine() {
    global scriptEnabled
    scriptEnabled := !scriptEnabled
    if (!scriptEnabled)
        HideBox()
}