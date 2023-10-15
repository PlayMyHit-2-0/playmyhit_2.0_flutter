import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/profile_bloc/profile_bloc.dart';
import 'package:playmyhit/logic/settings_bloc/settings_bloc.dart';
import 'package:playmyhit/presentation/profile_screen/action_bar.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/post_card.dart';
import 'package:playmyhit/presentation/profile_screen/profile_banner.dart';
import 'package:playmyhit/presentation/profile_screen/profile_info.dart';

class AuthorizedView extends StatefulWidget{
  final SettingsBloc settingsBloc;
  final ProfileBloc profileBloc;
  const AuthorizedView({super.key, required this.settingsBloc, required this.profileBloc});

  @override
  State<StatefulWidget> createState() {
    return AuthorizedViewState();
  }
}

class AuthorizedViewState extends State<AuthorizedView> {
  final ScrollController _mainScrollController = ScrollController();

  @override
  void initState() {
    _mainScrollController.addListener(_mainScrollControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  _mainScrollControllerListener(){
    // print("Scrolling");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: SingleChildScrollView(
          controller: _mainScrollController,
          child : BlocBuilder<SettingsBloc, SettingsBlocState>(
              bloc: widget.settingsBloc,
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
                          BlocListener(
                            bloc: BlocProvider.of<ProfileBloc>(context),
                            listener :(context, state){
                              if(state.runtimeType == NavigateToMusicPageState){
                                Navigator.of(context).pushNamed("/music");
                              }
                            },
                            child: BlocProvider.value(value: BlocProvider.of<ProfileBloc>(context), child: const ActionBar()),
                          ),
                          const SizedBox(height: 5),
                          StreamBuilder(
                            stream: RepositoryProvider.of<PostsRepository>(context).postsStream,
                            builder: (context, snapshot){
                              if(snapshot.hasData){
                                return BlocConsumer<ProfileBloc, ProfileState>(
                                  bloc: widget.profileBloc,
                                  listenWhen: (previous, current) => current.runtimeType == ProfileScrollToTopState,
                                  buildWhen: (previous, current) => current.runtimeType != ProfileActionState,
                                  builder: (context,state) => ListView.builder(
                                    // controller: _mainScrollController,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder:(context, index) => PostCard(post: snapshot.data![index]),
                                  ),
                                  listener: (context, state) async {
                                    if(state.runtimeType == ProfileScrollToTopState){
                                      _mainScrollController.animateTo(460.0, duration: const Duration(seconds: 1), curve: Curves.bounceInOut);
                                    }
                                  },
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
          ),
      ),
    );
  }
}