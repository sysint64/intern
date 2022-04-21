import 'package:drivers/lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LifecycleAwareBloc<E, S> extends Bloc<E, S> implements LifecycleAware {
  bool _isClosed = false;
  final _lifecycles = <Lifecycle>[];

  LifecycleAwareBloc(S initialState) : super(initialState);

  @override
  void registerLifecycle(Lifecycle lifecycle) {
    _lifecycles.add(lifecycle);
  }

  @override
  void add(E event) {
    if (!_isClosed) {
      super.add(event);
    }
  }

  @override
  Future<void> close() async {
    _isClosed = true;

    for (final lifecycle in _lifecycles) {
      lifecycle.disposeLifecycle();
    }

    return super.close();
  }
}

BlocBuilder<B, S> blocState<B extends Cubit<S>, S>(
  BlocWidgetBuilder<S> builder,
) =>
    BlocBuilder(builder: builder);

BlocBuilder<B, S> blocWhenState<B extends Cubit<S>, S, SS extends S>(
  BlocWidgetBuilder<SS> builder,
) =>
    BlocBuilder(
      builder: (context, state) {
        if (state is SS) {
          return builder(context, state);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
