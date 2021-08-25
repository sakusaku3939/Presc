import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presc/config/playback_style_config.dart';
import 'package:presc/config/playback_text_style.dart';
import 'package:presc/config/sample_text_config.dart';
import 'package:presc/config/scroll_speed_config.dart';
import 'package:presc/view/utils/horizontal_text.dart';
import 'package:presc/view/utils/radio_dialog_manager.dart';
import 'package:presc/view/utils/ripple_button.dart';
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
              return Column(
                children: [
                  model.scrollVertical
                      ? _verticalPreview(model)
                      : _horizontalPreview(),
                  _menu(context, model),
                  SizedBox(height: 8),
                  Ink(
                    color: Colors.white,
                    child: ListTile(
                      title: Text("書式の向き"),
                      subtitle: Text(model.scrollVertical ? "横書き" : "縦書き"),
                      contentPadding: EdgeInsets.only(left: 32),
                      onTap: () => {
                        RadioDialogManager.show(
                          context,
                          groupValue: model.scrollVertical,
                          itemList: [
                            RadioDialogItem(
                              title: "横書き",
                              value: true,
                            ),
                            RadioDialogItem(
                              title: "縦書き",
                              value: false,
                            ),
                          ],
                          onChanged: (value) => model.scrollVertical = value,
                        )
                      },
                    ),
                  ),
                  Ink(
                    color: Colors.white,
                    child: ListTile(
                      title: Text("再生モード"),
                      subtitle: Text(
                        model.scrollMode == ScrollMode.manual
                            ? "手動スクロール"
                            : model.scrollMode == ScrollMode.auto
                                ? "自動スクロール"
                                : "音声認識",
                      ),
                      contentPadding: EdgeInsets.only(left: 32),
                      onTap: () => RadioDialogManager.show(
                        context,
                        groupValue: model.scrollMode,
                        itemList: [
                          RadioDialogItem(
                            title: "手動スクロール",
                            subtitle: "スクロールを行いません",
                            value: ScrollMode.manual,
                          ),
                          RadioDialogItem(
                            title: "自動スクロール",
                            subtitle: "一定の速度でスクロールします",
                            value: ScrollMode.auto,
                          ),
                          RadioDialogItem(
                            title: "音声認識",
                            subtitle: "認識した文字分だけスクロールします",
                            value: ScrollMode.recognition,
                          ),
                        ],
                        onChanged: (value) => model.scrollMode = value,
                      ),
                    ),
                  ),
                  Ink(
                    color: Colors.white,
                    child: ListTile(
                      title: Text("再生速度"),
                      subtitle: Text("x ${model.scrollSpeedMagnification}"),
                      contentPadding: EdgeInsets.only(left: 32),
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
                  ),
                  SizedBox(height: 16),
                  Ink(
                    color: Colors.white,
                    child: ListTile(
                      title: Text("このアプリについて"),
                      contentPadding: EdgeInsets.only(left: 32),
                      onTap: () => {},
                    ),
                  ),
                  Ink(
                    color: Colors.white,
                    child: ListTile(
                      title: Text("オープンソースライセンス"),
                      contentPadding: EdgeInsets.only(left: 32),
                      onTap: () => {},
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

  Widget _appbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "再生設定",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _verticalPreview(PlaybackProvider model) {
    final ScrollController scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(32);
    });
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 32),
      color: Colors.grey[900],
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        gradientFractionOnStart: 0.5,
        gradientFractionOnEnd: 0.5,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              SampleTextConfig.setting,
              style: PlaybackTextStyle.of(model).unrecognized,
            ),
          ),
        ),
      ),
    );
  }

  Widget _horizontalPreview() {
    final ScrollController scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent - 32);
    });
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey[900],
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        gradientFractionOnStart: 0.3,
        gradientFractionOnEnd: 0.3,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: HorizontalText(
              unrecognizedText: SampleTextConfig.setting,
              recognizedText: "",
            ),
          ),
        ),
      ),
    );
  }

  Widget _menu(BuildContext context, PlaybackProvider model) {
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
              primary: Colors.grey[700],
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
                        initialItem: PlaybackStyleConfig.fontSizeList
                            .indexOf(model.fontSize),
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
              primary: Colors.grey[700],
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
                        initialItem: PlaybackStyleConfig.fontHeightList
                            .indexOf(model.fontHeight),
                      ),
                      children: [
                        for (var fontHeight in PlaybackStyleConfig.fontHeightList)
                          Text(fontHeight.toString())
                      ],
                      onSelectedItemChanged: (index) => {
                        model.fontHeight = PlaybackStyleConfig.fontHeightList[index]
                      },
                    ),
                  );
                },
              ),
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.format_color_text),
            label: Text('□'),
            style: TextButton.styleFrom(
              primary: Colors.grey[700],
            ),
            onPressed: () => {},
          ),
          TextButton.icon(
            icon: Icon(Icons.format_color_fill),
            label: Text('■'),
            style: TextButton.styleFrom(
              primary: Colors.grey[700],
            ),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
