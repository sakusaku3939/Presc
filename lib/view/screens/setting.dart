import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';
import 'package:presc/config/playback_style_config.dart';
import 'package:presc/config/playback_text_style.dart';
import 'package:presc/config/sample_text_config.dart';
import 'package:presc/config/scroll_speed_config.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/view/screens/about_app.dart';
import 'package:presc/view/screens/setting_undo_redo.dart';
import 'package:presc/view/utils/dialog/color_dialog_manager.dart';
import 'package:presc/view/utils/dialog/radio_dialog_manager.dart';
import 'package:presc/view/utils/dialog/scroll_mode_dialog_manager.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/setting_item.dart';
import 'package:presc/view/utils/tategaki.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appbar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<PlaybackProvider>(
            builder: (context, model, child) {
              String scrollModeText;
              switch (model.scrollMode) {
                case ScrollMode.manual:
                  scrollModeText = S.current.manualScroll;
                  break;
                case ScrollMode.auto:
                  scrollModeText = S.current.autoScroll;
                  break;
                case ScrollMode.recognition:
                  scrollModeText = S.current.speechRecognition;
                  break;
              }
              return Column(
                children: [
                  model.scrollHorizontal
                      ? _horizontalPreview(model)
                      : _verticalPreview(model),
                  _textMenu(context, model),
                  SizedBox(height: 8),
                  SettingItem(
                    title: S.current.formatOrientation,
                    subtitle: model.scrollHorizontal
                        ? S.current.horizontal
                        : S.current.vertical,
                    onTap: () => {
                      RadioDialogManager.show(
                        context,
                        groupValue: model.scrollHorizontal,
                        itemList: [
                          RadioDialogItem(
                            title: S.current.horizontal,
                            value: true,
                          ),
                          RadioDialogItem(
                            title: S.current.vertical,
                            value: false,
                          ),
                        ],
                        onChanged: (value) => model.scrollHorizontal = value,
                      )
                    },
                  ),
                  SettingItem(
                    title: S.current.undoRedoButton,
                    subtitle:
                        model.showUndoRedo ? S.current.show : S.current.hide,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SettingUndoRedoScreen(),
                      ),
                    ),
                  ),
                  SettingItem(
                    title: S.current.playMode,
                    subtitle: scrollModeText,
                    onTap: () => ScrollModeDialogManager.show(context),
                  ),
                  SettingItem(
                    title: S.current.playSpeed,
                    subtitle: "x ${model.scrollSpeedMagnification}",
                    enabled: model.scrollMode == ScrollMode.auto,
                    onTap: () => RadioDialogManager.show(
                      context,
                      groupValue: model.scrollSpeedMagnification,
                      itemList: [
                        for (var speed in ScrollSpeedConfig.magnification)
                          RadioDialogItem(
                            title: "x $speed",
                            value: speed,
                          ),
                      ],
                      onChanged: (value) =>
                          model.scrollSpeedMagnification = value,
                    ),
                  ),
                  SizedBox(height: 16),
                  SettingItem(
                    title: S.current.aboutApp,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AboutAppScreen(),
                      ),
                    ),
                  ),
                  SettingItem(
                    title: S.current.ossLicence,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LicensePage(),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        S.current.playSetting,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _horizontalPreview(PlaybackProvider model) {
    final ScrollController scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(32);
    });
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      color: model.backgroundColor,
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        gradientFractionOnStart: 0.5,
        gradientFractionOnEnd: 0.5,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              SampleTextConfig().setting,
              style: PlaybackTextStyle.of(model).unrecognized,
              strutStyle: PlaybackTextStyle.of(model).strutStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _verticalPreview(PlaybackProvider model) {
    final ScrollController scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent - 32);
    });
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: model.backgroundColor,
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        gradientFractionOnStart: 0.3,
        gradientFractionOnEnd: 0.3,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Container(
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Tategaki(
              recognizedText: "",
              unrecognizedText: SampleTextConfig().setting,
            ),
          ),
        ),
      ),
    );
  }

  Widget _textMenu(BuildContext context, PlaybackProvider model) {
    return Container(
      height: 40,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            icon: Icon(Icons.format_size),
            label: Text(model.fontSize.toString()),
            style: TextButton.styleFrom(
              primary: ColorConfig.iconColor,
            ),
            onPressed: () => {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return Container(
                    height: 180,
                    color: Colors.white,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(
                        initialItem: PlaybackStyleConfig.fontSizeList.indexOf(
                          model.fontSize,
                        ),
                      ),
                      children: [
                        for (var fontSize in PlaybackStyleConfig.fontSizeList)
                          Text(fontSize.toString())
                      ],
                      onSelectedItemChanged: (index) => {
                        model.fontSize = PlaybackStyleConfig.fontSizeList[index]
                      },
                    ),
                  );
                },
              ),
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.format_line_spacing),
            label: Text(model.fontHeight.toString()),
            style: TextButton.styleFrom(
              primary: ColorConfig.iconColor,
            ),
            onPressed: () => {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return Container(
                    height: 180,
                    color: Colors.white,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(
                        initialItem: PlaybackStyleConfig.fontHeightList.indexOf(
                          model.fontHeight,
                        ),
                      ),
                      children: [
                        for (var fontHeight
                            in PlaybackStyleConfig.fontHeightList)
                          Text(fontHeight.toString())
                      ],
                      onSelectedItemChanged: (index) => {
                        model.fontHeight =
                            PlaybackStyleConfig.fontHeightList[index]
                      },
                    ),
                  );
                },
              ),
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.format_color_text),
            label: _selectColorSquare(model.textColor),
            style: TextButton.styleFrom(
              primary: ColorConfig.iconColor,
            ),
            onPressed: () => ColorDialogManager.show(
              context,
              pickerColor: model.textColor,
              initialColor: ColorConfig.playbackTextColor,
              onSubmitted: (color) => model.textColor = color,
            ),
          ),
          TextButton.icon(
            icon: Icon(Icons.format_color_fill),
            label: _selectColorSquare(model.backgroundColor),
            style: TextButton.styleFrom(
              primary: ColorConfig.iconColor,
            ),
            onPressed: () => ColorDialogManager.show(
              context,
              pickerColor: model.backgroundColor,
              initialColor: ColorConfig.playbackBackgroundColor,
              onSubmitted: (color) => model.backgroundColor = color,
            ),
          ),
        ],
      ),
    );
  }

  Text _selectColorSquare(Color color) => color == Colors.white
      ? Text("□")
      : Text("■", style: TextStyle(color: color));
}
