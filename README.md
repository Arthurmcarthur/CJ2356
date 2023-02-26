# 倉頡三五

由Jeremy Wu的[DIME開源專項](https://github.com/jrywu/DIME)修改而來。

本項目受日月遞照的[倉頡輸入2356](https://github.com/fszhouzzOrgOne/CangJieIM2356)啓發而來。

鳴謝[倉頡之友·倉頡之友](https://chinesecj.com/)和阿勤先生對本項目的支持，歡迎[捐助倉頡之友](https://chinesecj.com/forum/forum.php?mod=viewthread&tid=2061)。

本項目使用了[倉頡三代補完計畫](https://github.com/Arthurmcarthur/Cangjie3-Plus) 。

本項目也使用了[倉頡五代補完計畫](https://github.com/Jackchows/Cangjie5) 。

本項目也使用了[雪齋的倉頡六代碼表](https://github.com/LEOYoon-Tsaw/Cangjie6) 。

本項目使用的倉頡系統托盤圖標來自[PIME](https://github.com/easyIME/PIME)。

## 下載

可以在Release處下載最新版本，也可以至倉頡之友下載。

## 緣由

數年前，有一個名叫「日月遞照」的倉頡用戶，在Android平台上開發了倉頡輸入2356及倉頡字典2356。2、3、5、6分別代表有人使用的2代、3代、5代和尚未公開的6代。
2019年，輕鬆輸入法團隊就為iOS平台開發了倉頡字典2356。
在今年為Windows二次開發適用於倉頡的平台時，阿勤表示2代和6代使用人數較少，名稱不如就刪去2和6，命名為倉頡三五。

## 優勢

1. 編碼至Unicode擴展H區，支持多達九萬餘個簡繁中日韓越漢字輸入。
2. 支持二代、三代、五代及六代倉頡，提供多種倉頡版本供各版本倉頡用戶使用。 
3. 所有倉頡碼表公開，方便移至各開放平臺，如手機等平臺。
4. 支持安裝在簡體和繁體語系之下。
5. 支持UWP应用，可在Microsoft Edge等應用之中使用。
6. 支持ARM64架構，可在運行Windows on ARM的電腦，如Thinkpad X13s、運行Parallels Desktop或VMWare Fusion的MacBook（2020年後）、Surface Pro X上使用。
7. 支持自定輸入法顯示字體。
8. 支持 * 號模糊輸入。
9. 附傳統注音，支持使用傳統注音打字或反查。 
10. 支持各類符號輸入。 
11. 支持自定詞庫、自定義輸入法方案。

## FAQ
1.為何360報毒？

A:因為本軟件不用於營利，沒有申請數字簽章；再加上安裝時寫Registry，會被一些敏感的殺毒軟件報毒。本輸入法是開源項目，沒有病毒，輸入法的源碼可供檢驗，也可將其上傳至VirusTotal掃描。但最終是否安裝，將考驗您的判斷力。如果您信任本軟件，建議在安裝時關閉360，或將本輸入法加入信任名單，避免防毒軟件對安裝過程干擾。

2.如何自定義聯想詞庫？

A:建議修改AppData\Roaming\CJ2356中的Phrase.txt。Phrase.txt以UTF-16 LE编码，換行符為CR LF（即\r\n）。

3.我想添加打詞詞庫？

A:在C:\Program Files\CJ2356下内置有两个码表文件，均为五代，可以直接使用。它们名为cj5-ftzk.txt和cj5-jtzk.txt。它也以UTF-16 LE編碼，換行符為CR LF。編碼和字之間以空白符分割。也可以自己準備詞庫，需符合以上格式。

## 反饋錯誤

若發現bug，可在此處或倉頡之友論壇[反饋](https://github.com/Arthurmcarthur/CJ2356/issues/new)。
另外，也會收集在下方「友情連接」中的地點反饋的錯誤。
非常感謝！

## 友情連接
- [「倉頡之友·馬來西亞」論壇](http://www.chinesecj.com/forum/forum.php)
- [「維基教科書·倉頡輸入法」教程](https://zh.m.wikibooks.org/zh-hant/倉頡輸入法)