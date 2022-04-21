import 'package:common_ui_services/material/material_snackbar_errors_notifications_service.dart';
import 'package:common_ui_services/material/material_snackbar_notifications_service.dart';
import 'package:debug_services/bloc/update_config_value_page/update_config_value_page_bloc.dart';
import 'package:debug_services/presenters/update_config_value_page_presenter.dart';
import 'package:debug_services/widgets.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/router/router.dart';
import 'package:drivers/ui/lifecycle_aware_widget_mixin.dart';
import 'package:error_services/errors_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

UpdateConfigValuePageBloc _bloc(BuildContext context) => BlocProvider.of(context);

class UpdateConfigValuePageProvider extends StatefulWidget {
  final String envKey;

  const UpdateConfigValuePageProvider(this.envKey, {Key? key}) : super(key: key);

  @override
  State<UpdateConfigValuePageProvider> createState() => _UpdateConfigValuePageProviderState();
}

class _UpdateConfigValuePageProviderState
    extends LifecycleAwareWidgetState<UpdateConfigValuePageProvider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateConfigValuePageBloc(
        widget.envKey,
        resolveDependency<AppRouter>(),
        resolveDependency<ErrorsService>(),
        MaterialSnackbarNotificationsService.attach(this),
        MaterialSnackbarErrorsNotificationsService.attach(this),
        resolveLifecycleDependency<UpdateConfigValuePagePresenter>().attach(this),
      )..add(const OnLoad()),
      child: const DebugUpdateConfigValuePage(),
    );
  }
}

class DebugUpdateConfigValuePage extends StatelessWidget {
  const DebugUpdateConfigValuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DebugServicesThemeWidget(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<UpdateConfigValuePageBloc, UpdateConfigValuePageState>(
            builder: (context, state) {
              if (state is LoadedState) {
                return Text(state.name);
              } else {
                return const Text('...');
              }
            },
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<UpdateConfigValuePageBloc, UpdateConfigValuePageState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadingErrorState) {
                return const SizedBox.shrink();
                // return AppLoadingErrorWidget(
                //   state.error,
                //   onRetry: () => _bloc(context).add(OnLoad()),
                // );
              } else if (state is LoadedState) {
                return _Loaded(state);
              } else {
                throw StateError('Unknown state: $state');
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Loaded extends StatefulWidget {
  final LoadedState state;

  const _Loaded(this.state, {Key? key}) : super(key: key);

  @override
  _LoadedState createState() => _LoadedState();
}

class _LoadedState extends State<_Loaded> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.text = widget.state.value;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.state is AwaitingSetValueState
                    ? null
                    : () => _bloc(context).add(OnUpdateValue(_controller.text)),
                child: const Text('Update'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
