import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    BlocProvider.of<ProfileBloc>(context).add(ProfileInitialEvent(posts: BlocProvider.of<ProfileBloc>(context).cachedPosts));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("Changed dependencies in profile page.");
    super.didChangeDependencies();
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
          child : Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              BlocBuilder<SettingsBloc, SettingsBlocState>(
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
                                  Navigator.of(context).pushNamed("/music").then((value) => BlocProvider.of<ProfileBloc>(context).add(ProfileInitialEvent(posts: BlocProvider.of<ProfileBloc>(context).cachedPosts)));
                                }else if(state.runtimeType == NavigateToVideosPageState){
                                  Navigator.of(context).pushNamed("/videos").then((value)=> BlocProvider.of<ProfileBloc>(context).add(ProfileInitialEvent(posts: BlocProvider.of<ProfileBloc>(context).cachedPosts)));
                                }else if(state.runtimeType == NavigateToPicturesPageState){
                                  Navigator.of(context).pushNamed("/pictures").then((value)=> BlocProvider.of<ProfileBloc>(context).add(ProfileInitialEvent(posts: BlocProvider.of<ProfileBloc>(context).cachedPosts)));
                                }
                              },
                              child: BlocProvider.value(value: BlocProvider.of<ProfileBloc>(context), child: const ActionBar()),
                            ),
                            const SizedBox(height: 5),
                          ]
                        )
                      );
                    default:
                      return const Center(
                        child: Text("Unkown State")
                      );
                  }
                }
              ),
              BlocConsumer<ProfileBloc, ProfileState>(
                bloc: widget.profileBloc,
                listenWhen: (previous, current){
                  if(current.runtimeType == ProfileScrollToTopState){
                    return true;
                  }
                  return false;
                },
                buildWhen: (previous, current){
                  if(current.runtimeType == ProfileScrollToTopState){
                    return false;
                  }else{
                    return true;
                  }
                },
                builder: (context,state){
                  if(state.runtimeType == ProfileLoadedState){
                    ProfileLoadedState st = state as ProfileLoadedState;
                    if(kDebugMode){
                      print("Rendering the following posts.");
                      print(st.posts);
                    }
                    
                    return ListView.builder(
                      // controller: _mainScrollController,
                      shrinkWrap: true,
                      itemCount: st.posts.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder:(context, index) => PostCard(post: st.posts[index]),
                    );
                    // return StreamBuilder(
                    //   stream: st.postsStream,
                    //   builder: (context, snapshot){
                    //     if(snapshot.hasData){
                    //       // BlocProvider.of<ProfileBloc>(context).add(ProfileInitialEvent());
                    //       List<Post> posts = snapshot.data ?? [];
                    //       return ListView.builder(
                    //         // controller: _mainScrollController,
                    //         shrinkWrap: true,
                    //         itemCount: posts.length,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemBuilder:(context, index) => PostCard(post: posts[index]),
                    //       );
                    //     }else{
                    //       return const Center(child: Text("Loading."));
                    //     }
                    //   },
                    // );
                  }else{
                    if(kDebugMode){
                      print("Did not receive ProfileInitialEvent.");
                      print("Received the following state.");
                      print(state.runtimeType);
                    }

                    return ListView(
                      shrinkWrap: true,
                      children: const [
                        ListTile(
                          title: Text("No Posts.")
                        )
                      ],
                    );
                  }
                },
                listener: (context, state) async {
                  if(state.runtimeType == ProfileScrollToTopState){
                    _mainScrollController.animateTo(460.0, duration: const Duration(seconds: 1), curve: Curves.bounceInOut);
                  }
                },
              )   
            ]
          )
        ),
      ),
    );
  }
}