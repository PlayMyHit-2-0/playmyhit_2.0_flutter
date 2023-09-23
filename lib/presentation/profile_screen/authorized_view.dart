import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/settings_bloc/settings_bloc.dart';
import 'package:playmyhit/presentation/profile_screen/profile_banner.dart';
import 'package:playmyhit/presentation/profile_screen/profile_info.dart';

class AuthorizedView extends StatefulWidget{
  final SettingsBloc bloc;
  const AuthorizedView({super.key, required this.bloc});

  @override
  State<StatefulWidget> createState() {
    return AuthorizedViewState();
  }
}

class AuthorizedViewState extends State<AuthorizedView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child : BlocBuilder<SettingsBloc, SettingsBlocState>(
          bloc: widget.bloc,
          buildWhen: (previous, current) => current.runtimeType != SettingsBlocActionState,      
          builder: (context, state){
            switch(state.runtimeType){
              case SettingsBlocLoadingState:
                return const Center(
                  child: Column(
                    children: [
                      Text("Loading "),
                      CircularProgressIndicator()
                    ]
                  )
                );
              case SettingsBlocLoadedState:
                SettingsBlocLoadedState st = state as SettingsBlocLoadedState;

                // RepositoryProvider.of<PostsRepository>(context).postsStream.forEach((List<Post> posts){
                //   for (var post in posts) {
                //     if (kDebugMode) {
                //       print(post.postAttachments);
                //     } 
                //   }
                // });
                

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileBanner(
                        profileBannerUrl: st.settingsDataModel?.profileBannerImageUrl ?? "",
                        profilePictureUrl: st.settingsDataModel?.profileImageUrl ?? "",
                        username: st.settingsDataModel?.username ?? ""
                      ),
                      Container(
                        height: 10,
                        color: Colors.redAccent
                      ),
                      ProfileInfo(
                        city: st.settingsDataModel?.city ?? "Unknown City",
                        state: st.settingsDataModel?.state ?? "Unknown State",
                        country : st.settingsDataModel?.country ?? "Unknown Country",
                        intro: st.settingsDataModel?.profileIntroduction ?? "No introduction provided."
                      ),
                      StreamBuilder(
                        stream: RepositoryProvider.of<PostsRepository>(context).postsStream,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(snapshot.data?[index].postText ?? "No Title") 
                              ),
                            );
                          }else{
                            return ListView(
                              shrinkWrap: true,
                              children: const [
                                ListTile(
                                  title: Text("No Posts"),
                                )
                              ],
                            );
                          }
                        },
                      )
                    ]
                  )
                );
              default:
                return const Center(
                  child: Text("Unkown State")
                );
            }
          }
        )
      );
  }
}