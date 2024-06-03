// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Widget _defaultChatroomList() {
//   return ValueListenableBuilder(
//       valueListenable: rebuildPagedList,
//       builder: (context, _, __) {
//         return PagedListView<int, LMChatTile>(
//           pagingController: homeFeedPagingController,
//           padding: EdgeInsets.zero,
//           physics: const ClampingScrollPhysics(),
//           builderDelegate: PagedChildBuilderDelegate<LMChatTile>(
//             firstPageProgressIndicatorBuilder: (context) =>
//                 widget.loadingPageWidget?.call(context) ??
//                 const LMChatSkeletonChatroomList(),
//             noItemsFoundIndicatorBuilder: (context) => const SizedBox(),
//             itemBuilder: (context, item, index) {
//               return item;
//             },
//           ),
//         );
//       });
// }
