import 'package:alice/alice.dart';
import 'package:common_device_services/copy_service.dart';
import 'package:common_ui_services/material/material_popups_service.dart';
import 'package:common_ui_services/material/material_snackbar_errors_notifications_service.dart';
import 'package:common_ui_services/material/material_snackbar_notifications_service.dart';
import 'package:debug_services/bloc/debug_services_page/debug_services_page_bloc.dart';
import 'package:debug_services/dashboard_builder.dart';
import 'package:debug_services/debug_services_module.dart';
import 'package:debug_services/presenters/debug_services_page_presenter.dart';
import 'package:debug_services/widgets.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/log.dart';
import 'package:drivers/router/router.dart';
import 'package:drivers/ui/lifecycle_aware_widget_mixin.dart';
import 'package:error_services/errors_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_loggy/flutter_loggy.dart';

DebugServicesPageBloc _bloc(BuildContext context) => BlocProvider.of(context);

class DebugServicesPageProvider extends StatefulWidget {
  const DebugServicesPageProvider({Key? key}) : super(key: key);

  @override
  State<DebugServicesPageProvider> createState() => _DebugServicesPageProviderState();
}

class _DebugServicesPageProviderState extends LifecycleAwareWidgetState<DebugServicesPageProvider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DebugServicesPageBloc(
        resolveDependency<AppRouter>(),
        resolveDependency<ErrorsService>(),
        MaterialSnackbarErrorsNotificationsService.attach(this),
        MaterialSnackbarNotificationsService.attach(this),
        MaterialPopupsService.attach(this),
        resolveLifecycleDependency<CopyService>().attach(this),
        resolveLifecycleDependency<DebugServicesPagePresenter>().attach(this),
      )..add(const OnLoad()),
      child: const DebugServicesPage(),
    );
  }
}

class DebugServicesPage extends StatelessWidget {
  const DebugServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _bloc(context).add(const OnClose());
        return false;
      },
      child: DebugServicesThemeWidget(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Debug Services'),
            actions: [
              IconButton(
                icon: const Icon(Icons.restore),
                onPressed: () => _bloc(context).add(const OnReset()),
              ),
            ],
          ),
          body: SafeArea(
            child: BlocBuilder<DebugServicesPageBloc, DebugServicesPageState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return const SizedBox.shrink();
                } else if (state is LoadingErrorState) {
                  return const SizedBox.shrink();
                } else if (state is LoadedState) {
                  return _Loaded(state);
                } else {
                  Log.error('Debug services', 'Unsupported state: $state');
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  final LoadedState state;

  final router = resolveDependency<AppRouter>();
  final config = resolveDependency<DebugServicesConfig>();
  final dashboardBuilder = resolveDependency<DebugServicesDashboardBuilder>();

  _Loaded(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alice = resolveDependencyOrNull<Alice>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const DebugServicesSectionTitleWidget('Menu'),
          // AppNavigatorButton(title: 'UI Kit', onTap: () => router.open(UIKitPath())),
          if (config.captureLog)
            DebugServicesNavigatorButtonWidget(
              title: 'Log',
              onTap: () {
                final route = MaterialPageRoute<void>(
                  builder: (_) => const LoggyStreamScreen(),
                );
                Navigator.of(context).push(route);
                // alice.showInspector();
              },
            ),
          if (alice != null)
            DebugServicesNavigatorButtonWidget(
              title: 'Network Inspector (Alice)',
              onTap: () {
                alice.showInspector();
              },
            ),
          ...dashboardBuilder.createMenuSection(context),
          const DebugServicesSectionTitleWidget('General Information'),
          DebugServicesInfoEntryWidget(title: 'Version', value: state.data.version),
          DebugServicesInfoEntryWidget(title: 'Build Number', value: state.data.buildNumber),
          DebugServicesInfoEntryWidget(title: 'Package Name', value: state.data.packageName),
          DebugServicesInfoEntryWidget(title: 'OS', value: state.data.os),
          DebugServicesInfoEntryWidget(title: 'OS Version', value: state.data.osVersion),
          const DebugServicesSectionTitleWidget('Config'),
          for (final key in state.data.config.fields.keys)
            _ConfigValueEntry(
              id: key,
              title: state.data.config.fields[key]!.name,
              value: state.data.config.container.getValueByKey<dynamic>(key).toString(),
            ),
          const DebugServicesSectionTitleWidget('Features'),
          for (final key in state.data.features.fields.keys)
            _FeatureValueEntry(
              state,
              id: key,
              title: state.data.features.fields[key]!.name,
              value: state.data.features.container.getValueByKey(key),
            ),
          // ...
        ],
      ),
    );
  }
}

class _ConfigValueEntry extends StatelessWidget {
  final String id;
  final String title;
  final String value;

  const _ConfigValueEntry({
    required this.id,
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DebugServicesNavigatorButtonWidget(
      title: title,
      subTitle: value,
      onTap: () => _bloc(context).add(OnUpdateConfigValueClick(id, value)),
    );
  }
}

class _FeatureValueEntry extends StatelessWidget {
  final String id;
  final String title;
  final bool value;
  final LoadedState state;

  const _FeatureValueEntry(
    this.state, {
    required this.id,
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DebugServicesStackedSwitchWidget(
      title: title,
      isChecked: value,
      onChanged:
          state is AwaitingState ? null : (_) => _bloc(context).add(OnUpdateFeature(id, !value)),
    );
  }
}
