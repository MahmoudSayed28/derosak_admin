

import 'package:derosak_admin/features/resources/data/models/resources_model.dart';

sealed class ResourceState {
  const ResourceState();
}

final class ResourceInitial extends ResourceState {}

final class ResourceLoading extends ResourceState {}

final class ResourceSuccess extends ResourceState {}

final class ResourceFailure extends ResourceState {
  final String message;

  const ResourceFailure(this.message);
}

final class ResourceLoaded extends ResourceState {
  final List<ResourceModel> resources;

  const ResourceLoaded(this.resources);
}