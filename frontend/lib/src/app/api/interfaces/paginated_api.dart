import 'dart:async';

import 'package:frontend/src/app/api/interfaces/baseApi.dart';
import 'package:frontend/src/app/model/factories/interfaces/model_factory.dart';

import '../../../config/api_config.dart';
import '../helpers/pagination_api.dart';

abstract class PaginatedApi<T> extends BaseApi {
  String _url;
  ModelFactory<T> _factory;

  PaginatedApi(super.client, this._url, this._factory);

  Future<Map<int, T>> getAll() async {
    // token is hardcoded, waiting for a ticket about saving jwt tokens to app state
    PaginationApi paginationApi = PaginationApi(
        _url,
        ApiConfig.token
    );

    List<dynamic> items = List<dynamic>.empty(growable: true);

    // get all conversations
    while(await paginationApi.hasNext(client)) {
      items.addAll(await paginationApi.getNextPage(client));
    }

    return _factory.parseModels(items);
  }

  Future<Map<int, T>> getFirst() async {
    // token is hardcoded, waiting for a ticket about saving jwt tokens to app state
    // create a pagination api object that queries only one object per page
    PaginationApi paginationApi = PaginationApi.custom(
        0,
        1,
        _url,
        ApiConfig.token,
        -1
    );

    return _factory.parseModels(await paginationApi.getNextPage(client));
  }

  Future<int> getMaxPage(int currentPage, int size) async {
    // token is hardcoded, waiting for a ticket about saving jwt tokens to app state
    PaginationApi paginationApi = PaginationApi.custom(
        currentPage,
        size,
        _url,
        ApiConfig.token,
        -1
    );

    return await paginationApi.getMaxPage(client);
  }

  Future<Map<int, T>> getNextPage(int currentPage, int size) async {
    // token is hardcoded, waiting for a ticket about saving jwt tokens to app state
    PaginationApi paginationApi = PaginationApi.custom(
        currentPage,
        size,
        _url,
        ApiConfig.token,
        -1
    );

    return _factory.parseModels(await paginationApi.getNextPage(client));
  }

  Future<bool> hasNext(int currentPage, int size) async {
    // token is hardcoded, waiting for a ticket about saving jwt tokens to app state
    PaginationApi paginationApi = PaginationApi.custom(
        currentPage,
        size,
        _url,
        ApiConfig.token,
        -1
    );

    return await paginationApi.hasNext(client);
  }

  PaginatedApi<T> copyWith(String urlParams);
}