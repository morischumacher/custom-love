import 'package:frontend/src/app/api/conversation_api.dart';
import 'package:frontend/src/app/api/interfaces/paginated_api.dart';

import '../model/conversation_model.dart';
import 'interfaces/paginated_service.dart';

class ConversationService extends PaginatedService<Conversation, ConversationApi> {
  ConversationService(super._api);

  @override
  PaginatedService<Conversation, ConversationApi> copyWith(String urlParams)
    => ConversationService(super.api.copyWith(urlParams));
}