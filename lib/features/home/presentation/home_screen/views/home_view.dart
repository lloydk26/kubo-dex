import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/cubits/home_cubit.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/models/home_state.dart';
import 'package:kubo_dex/shared/widgets/error_view.dart';
import 'package:kubo_dex/shared/widgets/loading_indicator.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance<HomeCubit>()..onInitialize(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kubo Dex'),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const LoadingIndicator();
            }

            if (state.hasError) {
              return ErrorView(
                message: state.errorMessage,
                onRetry: () => context.read<HomeCubit>().loadItems(),
              );
            }

            if (state.items.isEmpty) {
              return const Center(
                child: Text('No items found'),
              );
            }

            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: item.description != null ? Text(item.description!) : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
