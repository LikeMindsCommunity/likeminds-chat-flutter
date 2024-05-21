import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';

part 'home_event.dart';
part 'home_state.dart';

class LMChatHomeBloc extends Bloc<LMChatHomeEvent, LMChatHomeState> {
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  final int pageSize = 20;

  static LMChatHomeBloc? _instance;
  static LMChatHomeBloc get instance => _instance ??= LMChatHomeBloc._();

  LMChatHomeBloc._() : super(LMChatHomeInitial()) {
    // final DatabaseReference realTime = LMRealtime.instance.homeFeed();
    // realTime.onValue.listen((event) {
    //   debugPrint(event.toString());
    //   add(UpdateHomeEvent());
    // });
    on<LMChatHomeEvent>(
      (event, emit) async {
        if (event is LMChatInitHomeEvent) {
          emit(LMChatHomeLoading());

          final response = await LMChatCore.client.getHomeFeed(event.request);
          if (response.success) {
            response.data?.conversationMeta?.forEach((key, value) {
              String? userId = value.userId == null
                  ? value.memberId?.toString()
                  : value.userId.toString();
              final user = response.data?.userMeta?[userId];
              value.member = user;
            });

            emit(LMChatHomeLoaded(response: response.data!));
          } else {
            LMChatHomeError(response.errorMessage!);
          }
        }
        if (event is LMChatUpdateHomeEvent) {
          final response = await LMChatCore.client.getHomeFeed(event.request ??
              (GetHomeFeedRequestBuilder()
                    ..page(1)
                    ..pageSize(pageSize)
                    ..minTimestamp(0)
                    ..maxTimestamp(currentTime)
                    ..chatroomTypes([10]))
                  .build());
          if (response.success) {
            emit(LMChatUpdatedHomeFeed());
            response.data?.conversationMeta?.forEach((key, value) {
              String? userId = value.userId == null
                  ? value.memberId?.toString()
                  : value.userId.toString();
              final user = response.data?.userMeta?[userId];
              value.member = user;
            });
            emit(LMChatUpdateHomeFeed(response: response.data!));
          } else {
            emit(LMChatHomeError(response.errorMessage ?? "An error occured"));
          }
        }
      },
    );
  }
}