export 'enums.dart';
export 'typedefs.dart';

export 'time_ago/time_ago.dart';
export 'time_ago/time_ago_message.dart';
export 'constants/constants.dart';

export 'helpers/tagging_helper.dart';
export 'helpers/text_helper.dart';

export 'media_provider/media_provider.dart';

String getInitials(String name) => name.isNotEmpty
    ? name
        .trim()
        .split(' ')
        .where((element) => element.isNotEmpty)
        .map((l) => l[0])
        .take(2)
        .join()
    : '';
