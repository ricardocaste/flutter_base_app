
import 'package:flutter_app/presentation/bloc/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter_app/infrastructure/di/di.dart';
import 'package:flutter_app/domain/entities/user.dart';
import 'package:flutter_app/presentation/bloc/authentication/authentication_cubit.dart';
import 'package:flutter_app/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter_app/presentation/widgets/app_bar_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profileCubit});

  final ProfileCubit profileCubit;

  @override
  State<ProfilePage> createState() => ProfilePagePageState();
}

class ProfilePagePageState extends State<ProfilePage> {
  final int listLength = 7;

  @override
  void initState() {
    super.initState();
    widget.profileCubit.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.profileCubit,
      child: const ProfileView());
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    User user = Get.find<User>(tag: 'user');

    return Scaffold(
      appBar: AppBarWidget(context: context, title: 'Profile', actions: [
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () async {
            final authCubit = getIt<AuthenticationCubit>();
            await authCubit.logOut(); 
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed('nav'); 
            }
          },
        ),
      ],
      backAction: () {
        Navigator.of(context).pushReplacementNamed('nav'); 
      },
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(  
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name!.isEmpty ? "Welcome!" : user.name!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(user.email ?? ''),

                  const SizedBox(height: 50),
                  Text(
                    'Statistics',
                    style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatisticCard(
                              'Statistic 1', context)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildStatisticCard('Statistic 2', context)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildStatisticCard('Statistic 3', context)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildStatisticCard('Statistic 4', context)),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          } else if (state is HomeError) {
            return const Center(child: Text('Error loading profile'));
          } else {
            return const SizedBox();
          }
      }
    )
  );
}

  Widget _buildStatisticCard(String title, BuildContext context) {
    return SizedBox(
        child: Card(
          color: Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 165, 138, 138) : const Color.fromARGB(22, 0, 0, 0),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 40),
                Text("hola", style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        )
    );
  }
}