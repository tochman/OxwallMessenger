@primaryFontName: AppleGothic;
@secondaryFontName: HelveticaNeue-Light;
@secondaryFontNameBold: HelveticaNeue;
@secondaryFontNameStrong: HelveticaNeue-Medium;
@inputFontName: HelveticaNeue;
@primaryFontColor: #555555;
@secondaryFontColor: #888888;
@primaryBackgroundColor: #E6E6E6;
@primaryBackgroundTintColor: #ECECEC;
@primaryBackgroundColorTop: #F3F3F3;
@primaryBackgroundColorBottom: #E6E6E6;
@primaryBackgroundColorBottomStrong: #DDDDDD;
@secondaryBackgroundColorTop: #FCFCFC;
@secondaryBackgroundColorBottom: #F9F9F9;
@primaryBorderColor: #A2A2A2;
@primaryBorderWidth: 1;

BarButton {
    background-color: @primaryBackgroundColor;
    background-color-highlighted: #CCCCCC;
    border-color: @primaryBorderColor;
    border-width: @primaryBorderWidth;
    corner-radius: 7;
    font-name: @secondaryFontNameBold;
    font-color: @primaryFontColor;
    font-color-disabled: @secondaryFontColor;
    font-size: 12;
    text-shadow-color: clear;
}
Button {
    background-color-top: #FFFFFF;
    background-color-bottom: @primaryBackgroundColorBottom;
    border-color: @primaryBorderColor;
    border-width: @primaryBorderWidth;
    font-color: @primaryFontColor;
    font-color-highlighted: @secondaryFontColor;
    font-name: @secondaryFontName;
    font-size: 14;
    height: 24;
    corner-radius: 5;
    exclude-views: UIAlertButton, UICheckbox, UIcontrol;
    exclude-subviews: UITableViewCell,UITextField;
}
LargeButton {
    height: 50;
    font-size: 20;
    corner-radius: 10;
}
SmallButton {
    height: 22;
    font-size: 12;
    corner-radius: 5;
}
Label {
    font-name: @secondaryFontName;
    font-color: @primaryFontColor;
    text-auto-fit: true;
    exclude-views: UICheckbox;
}
LargeLabel {
    font-size: 24;
}
SmallLabel {
    font-size: 15;
}
NavigationBar {
    font-name: @secondaryFontName;
    font-size: 20;
    font-color: @primaryFontColor;
    text-shadow-color: clear;
    background-color-top: @primaryBackgroundColorTop;
    background-color-bottom: @primaryBackgroundColorBottomStrong;
}
SearchBar {
    background-color-top: @primaryBackgroundColorTop;
    background-color-bottom: @primaryBackgroundColorBottom;
    scope-background-color: #FFFFFF;
}
SegmentedControl {
    background-color: @primaryBackgroundColorTop;
    background-color-selected: @primaryBackgroundColorBottomStrong;
    border-color: @primaryBorderColor;
    border-width: @primaryBorderWidth;
    corner-radius: 7;
    font-name: @secondaryFontNameBold;
    font-size: 13;
    font-color: @primaryFontColor;
    text-shadow-color: clear;
}
Switch {
    on-tint-color: @primaryBackgroundTintColor;
}
TabBar {
    background-color-top: @primaryBackgroundColorTop;
    background-color-bottom: @primaryBackgroundColorBottom;
}
TabBarItem {
    font-name: @secondaryFontName;
    font-color: @primaryFontColor;
    font-size: 18;
    text-offset: 0,-11;
}
TableCell {
    background-color-top: @secondaryBackgroundColorTop;
    background-color-bottom: @secondaryBackgroundColorBottom;
    font-color: @primaryFontColor;
    font-name: @secondaryFontNameBold;
    font-size: 17;
}
TableCellDetail {
    font-name: @secondaryFontName;
    font-size: 14;
    font-color: @secondaryFontColor;
}
TextField {
    height: 20;
    font-color: @primaryFontColor;
    font-name: @primaryFontName;
    font-size: 14;
    background-color: #FFFFFF;
    border-style: none;
    border-color: @primaryBorderColor;
    border-width: 1;
    corner-radius: 5;
    padding: 10;
    vertical-align: center;
    exclude-views: UICheckbox;
    }
View {
    background-color: @primaryBackgroundColor;
    background-image: NUIViewBackground.png;
}
UICheckbox {
exclude-views: UIcontrol;

}