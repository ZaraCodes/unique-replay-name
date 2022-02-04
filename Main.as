bool windowVisible = false;
bool replaceName = true;
bool countingMode = true;
int countingIndex = 0;
int amountOfDigits = 4;
string replayName = "";
bool uniqueStringSet = false;

void Main() {
#if MP4
    CGameCtnApp@ app = GetApp();
    while (app.BasicDialogs is null) {
        yield();
    }
    auto basicDialogs = app.BasicDialogs;
    
    while (true) {
        if (replaceName && basicDialogs.DialogSaveAs_Path.StartsWith("Replays")) {
            if (string(basicDialogs.String).get_Length() > 0 && !uniqueStringSet) {
                if (countingMode) {
                    print(replayName.get_Length() + amountOfDigits);
                    if (replayName.get_Length() + amountOfDigits > 10) {
                        replayName = replayName.SubStr(0, 10 - amountOfDigits);
                        print(replayName);
                    }
                    basicDialogs.String = replayName;

                    // Adds '0' until the rest of the digits can be filled with the counter
                    for (int i = tostring(countingIndex).get_Length(); i < amountOfDigits; i++) {
                        basicDialogs.String = basicDialogs.String + "0";
                    }
                    // Adds the counter to the String
                    basicDialogs.String = basicDialogs.String + tostring(countingIndex);
                    countingIndex += 1;
                } else {
                    // Adds the timestamp to the replay name 
                    Time::Info timestamp = Time::Parse(Time::get_Stamp());
                    basicDialogs.String = string(basicDialogs.String) + "_" + timestamp.Year + "-" + timestamp.Month + "-" + timestamp.Day + "_" + timestamp.Hour + "-" + timestamp.Minute + "-" + timestamp.Second;
                }
                uniqueStringSet = true;
            } else if (uniqueStringSet && basicDialogs.DialogSaveAs_Files.get_Length() == 0) {
                uniqueStringSet = false;
                basicDialogs.String = "";
            }
        }
        sleep(100);
    }
#endif
}

void RenderMenu() {
    if (UI::MenuItem("Unique Replay Name")) {
        windowVisible = !windowVisible;
    }
}

void RenderInterface() {
    if (windowVisible) {
        UI::SetNextWindowSize(500, 200);
        UI::Begin("Replay Name Settings", windowVisible);
        replaceName = UI::Checkbox("Replace Replay Name", replaceName);
        countingMode = UI::Checkbox("Counting mode", countingMode);

        if (countingMode) {
            UI::Separator();
            replayName = UI::InputText("Replay name", replayName);
            amountOfDigits = UI::InputInt("Max amount of digits", amountOfDigits);
            countingIndex = UI::InputInt("Counting index", countingIndex);
            
            if (amountOfDigits < 1) {
                amountOfDigits = 1;
            }
            if (countingIndex < 0) {
                countingIndex = 0;
            } else {
                while (tostring(countingIndex).get_Length() > amountOfDigits) {
                    countingIndex = countingIndex / 10;
                }
            }
        }
        UI::End();
    }
}
