import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/preview/builder.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

/// {@template lm_chat_media_preview_screen}
/// A screen to preview media before adding attachments to a conversation
///
/// Creates a new instance for [LMChatMediaPreviewScreen]
///
/// Gives access to customizations through instance builder variables
///
/// To configure the page, use [LMChatMediaForwardingScreenConfig]
/// {@endtemplate}
class LMChatMediaPreviewScreen extends StatefulWidget {
  /// required conversation object to fetch media and title
  final LMChatConversationViewData? conversation;

  /// Controls whether to show the preview bar at the bottom
  final bool showPreview;

  /// {@macro lm_chat_media_preview_screen}
  const LMChatMediaPreviewScreen({
    super.key,
    this.conversation,
    this.showPreview = false,
  });

  @override
  State<LMChatMediaPreviewScreen> createState() =>
      _LMChatMediaPreviewScreenState();
}

class _LMChatMediaPreviewScreenState extends State<LMChatMediaPreviewScreen> {
  late ValueNotifier<int> _currentPosition;
  List<LMChatMediaModel> mediaList = [];
  late CarouselSliderController _carouselController;

  final LMChatMediaPreviewBuilderDelegate _screenBuilder =
      LMChatCore.config.mediaPreviewConfig.builder;

  @override
  void initState() {
    super.initState();
    mediaList = LMChatMediaHandler.instance.pickedMedia;
    _currentPosition = ValueNotifier<int>(0);
    _carouselController = CarouselSliderController();
  }

  @override
  void dispose() {
    _currentPosition.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LMChatMediaPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    mediaList = LMChatMediaHandler.instance.pickedMedia;
  }

  @override
  void deactivate() {
    LMChatMediaHandler.instance.clearPickedMedia();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: LMChatTheme.themeNotifierBloc,
        builder: (context, _, child) {
          return _screenBuilder.scaffold(
            onPopInvoked: (p0) {
              LMChatMediaHandler.instance.clearPickedMedia();
            },
            systemUiOverlay: SystemUiOverlayStyle.light,
            backgroundColor: LMChatTheme.isThemeDark
                ? LMChatTheme.theme.container
                : LMChatTheme.theme.onContainer,
            appBar: _screenBuilder.appBarBuilder(
              context,
              _defAppBar(),
              LMChatMediaHandler.instance.pickedMedia.length,
              _currentPosition.value,
            ),
            body: ValueListenableBuilder(
              valueListenable: _currentPosition,
              builder: (context, _, __) {
                return getMediaPreview();
              },
            ),
            bottomNavigationBar: widget.showPreview
                ? ValueListenableBuilder(
                    valueListenable: _currentPosition,
                    builder: (context, _, __) {
                      return (mediaList.isNotEmpty)
                          ? _screenBuilder.mediaPreviewBuilder(
                              context,
                              LMChatMediaHandler.instance.pickedMedia.copy(),
                              _currentPosition.value,
                              _defPreviewBar(),
                            )
                          : const SizedBox.shrink();
                    },
                  )
                : null,
          );
        });
  }

  LMChatAppBar _defAppBar() {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 60,
        gap: 12,
        backgroundColor: LMChatTheme.isThemeDark
            ? LMChatTheme.theme.container.withOpacity(0.5)
            : LMChatTheme.theme.onContainer.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
      leading: LMChatButton(
        onTap: () {
          LMChatMediaHandler.instance.clearPickedMedia();
          Navigator.pop(context);
        },
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.arrow_back,
          style: LMChatIconStyle(
            color: LMChatTheme.isThemeDark
                ? LMChatTheme.theme.onContainer
                : LMChatTheme.theme.container,
          ),
        ),
      ),
      title: LMChatText(
        widget.conversation == null
            ? "Attachments"
            : widget.conversation!.member!.name,
        style: LMChatTextStyle(
          maxLines: 1,
          padding: const EdgeInsets.only(top: 2),
          textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: LMChatTheme.isThemeDark
                    ? LMChatTheme.theme.onContainer
                    : LMChatTheme.theme.container,
              ),
        ),
      ),
      subtitle: _buildAppBarSubtitle(),
    );
  }

  Widget _buildAppBarSubtitle() {
    return ValueListenableBuilder(
      valueListenable: _currentPosition,
      builder: (context, position, _) {
        final DateTime now = DateTime.now();
        final String formattedDate =
            DateFormat('dd MMM yyyy, HH:mm').format(now);

        return LMChatText(
          "${position + 1} of ${mediaList.length} attachments • $formattedDate",
          style: LMChatTextStyle(
            maxLines: 1,
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: LMChatTheme.isThemeDark
                      ? LMChatTheme.theme.onContainer
                      : LMChatTheme.theme.container,
                ),
          ),
        );
      },
    );
  }

  String _getMonth(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Widget getMediaPreview() {
    if (mediaList.isEmpty) {
      return const SizedBox();
    }

    return PhotoViewGestureDetectorScope(
      axis: Axis.horizontal,
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: mediaList.length,
        options: CarouselOptions(
          height: 90.h,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          animateToClosest: false,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            _currentPosition.value = index;
          },
        ),
        itemBuilder: (context, index, realIndex) {
          final media = mediaList[index];
          return Container(
            color: LMChatTheme.isThemeDark
                ? LMChatTheme.theme.container
                : LMChatTheme.theme.onContainer,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Center(
                child: media.mediaType == LMChatMediaType.image
                    ? _screenBuilder.image(
                        context,
                        _buildImageWidget(media),
                        media,
                      )
                    : _screenBuilder.video(
                        context,
                        _buildVideoWidget(media),
                        media,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container _defPreviewBar() {
    return Container(
      decoration: BoxDecoration(
          color: LMChatTheme.theme.container,
          border: Border(
            top: BorderSide(
              color: LMChatTheme.theme.disabledColor,
              width: 0.1,
            ),
          )),
      padding: EdgeInsets.only(
        left: 2.w,
        right: 5.0,
        top: 2.h,
        bottom: 4.h,
      ),
      child: SizedBox(
        height: 15.w,
        child: _defPreviewList(),
      ),
    );
  }

  ListView _defPreviewList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: mediaList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => ValueListenableBuilder(
        valueListenable: _currentPosition,
        builder: (context, currentPos, _) {
          return GestureDetector(
            onTap: () {
              _carouselController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: currentPos == index
                    ? Border.all(
                        color: LMChatTheme.theme.secondaryColor,
                        width: 2.0,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      )
                    : null,
              ),
              width: 15.w,
              height: 15.w,
              child: mediaList[index].mediaType == LMChatMediaType.image
                  ? _buildThumbnailImage(mediaList[index])
                  : _buildThumbnailVideo(mediaList[index]),
            ),
          );
        },
      ),
    );
  }

  LMChatImage _buildImageWidget(LMChatMediaModel media) {
    return LMChatImage(
      imageUrl: media.mediaUrl,
      imageFile: media.mediaFile,
      style: LMChatImageStyle(
        boxFit: BoxFit.cover,
        height: media.height?.toDouble(),
        width: media.width?.toDouble(),
      ),
    );
  }

  LMChatImage _buildThumbnailImage(LMChatMediaModel media) {
    return LMChatImage(
      imageUrl: media.thumbnailUrl ?? media.mediaUrl,
      imageFile: media.thumbnailFile ?? media.mediaFile,
      style: LMChatImageStyle(
        boxFit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8.0),
        width: 100.w,
      ),
    );
  }

  LMChatVideo _buildVideoWidget(LMChatMediaModel media) => LMChatVideo(
        media: media,
        key: ObjectKey(media.hashCode),
      );

  Widget _buildThumbnailVideo(LMChatMediaModel media) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          LMChatImage(
            imageUrl: media.thumbnailUrl,
            imageFile: media.thumbnailFile,
            style: const LMChatImageStyle(
              boxFit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
