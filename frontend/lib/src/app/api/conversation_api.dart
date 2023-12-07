import 'package:frontend/src/app/api/helpers/pagination_api.dart';
import 'package:frontend/src/app/api/interfaces/paginated_api.dart';
import 'package:frontend/src/app/model/factories/conversation_factory.dart';
import 'package:http/http.dart' as http;

import '../../config/api_config.dart';
import '../model/conversation_model.dart';

class ConversationApi extends PaginatedApi<Conversation> {
  ConversationApi(http.Client client): super(client, "conversations/", ConversationFactory());
  ConversationApi.url(http.Client client, String urlParams): super(client, "conversations/$urlParams", ConversationFactory());

  @override
  ConversationApi copyWith(String urlParams) =>
      ConversationApi.url(
        client,
        urlParams
      );
}