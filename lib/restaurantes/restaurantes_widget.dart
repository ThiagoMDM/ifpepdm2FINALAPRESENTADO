import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '../conf_project/my_icon_button.dart';
import '../conf_project/my_theme.dart';
import '../conf_project/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'restaurantes_model.dart';
export 'restaurantes_model.dart';

class RestaurantesWidget extends StatefulWidget {
  const RestaurantesWidget({Key? key}) : super(key: key);

  @override
  _RestaurantesWidgetState createState() => _RestaurantesWidgetState();
}

class _RestaurantesWidgetState extends State<RestaurantesWidget> {
  late RestaurantesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RestaurantesModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF705FFF),
        drawer: Drawer(
          elevation: 16.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: ProjectTheme.of(context).secondaryBackground,
                      ),
                      child: AuthUserStreamWidget(
                        builder: (context) => StreamBuilder<List<UsersRecord>>(
                          stream: queryUsersRecord(
                            singleRecord: true,
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ProjectTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                valueOrDefault(currentUserDocument?.img, ''),
                                width: 300.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthUserStreamWidget(
                            builder: (context) => Text(
                              currentUserDisplayName,
                              style: ProjectTheme.of(context).bodyMedium,
                            ),
                          ),
                          Text(
                            currentUserEmail,
                            style: ProjectTheme.of(context).bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 4.0, 0.0),
                          child: ProjectIconButton(
                            borderColor: ProjectTheme.of(context).alternate,
                            borderWidth: 1.0,
                            buttonSize: 40.0,
                            fillColor: ProjectTheme.of(context).info,
                            icon: Icon(
                              Icons.logout,
                              color: Color(0xFFB72A0B),
                              size: 24.0,
                            ),
                            onPressed: () async {
                              GoRouter.of(context).prepareAuthEvent();
                              await authManager.signOut();
                              GoRouter.of(context).clearRedirectLocation();

                              context.goNamedAuth('login', context.mounted);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: ProjectTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: ProjectIconButton(
            borderColor: ProjectTheme.of(context).primary,
            borderRadius: 20.0,
            borderWidth: 1.0,
            buttonSize: 40.0,
            fillColor: ProjectTheme.of(context).accent1,
            icon: Icon(
              Icons.menu,
              color: ProjectTheme.of(context).info,
              size: 24.0,
            ),
            onPressed: () async {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: Text(
            'Restaurantes',
            style: ProjectTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            ProjectIconButton(
              borderColor: ProjectTheme.of(context).primary,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: ProjectTheme.of(context).accent1,
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: ProjectTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.pushNamed(
                  'carrinho',
                  queryParameters: {
                    'refrestaurantes': serializeParam(
                      null,
                      ParamType.DocumentReference,
                    ),
                  }.withoutNulls,
                );
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Listar restaurantes da listview
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                  child: StreamBuilder<List<RestaurantesRecord>>(
                    stream: queryRestaurantesRecord(),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ProjectTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      List<RestaurantesRecord>
                          listviewRestaurantesRestaurantesRecordList =
                          snapshot.data!;
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount:
                            listviewRestaurantesRestaurantesRecordList.length,
                        itemBuilder: (context, listviewRestaurantesIndex) {
                          final listviewRestaurantesRestaurantesRecord =
                              listviewRestaurantesRestaurantesRecordList[
                                  listviewRestaurantesIndex];
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 10.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                // Levar parametros Subcolections

                                context.pushNamed(
                                  'produtos',
                                  queryParameters: {
                                    'refrestaurantes': serializeParam(
                                      listviewRestaurantesRestaurantesRecord
                                          .reference,
                                      ParamType.DocumentReference,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: ProjectTheme.of(context).alternate,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0xFF2B2942),
                                      offset: Offset(0.0, 2.0),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Color(0x001B1414),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        listviewRestaurantesRestaurantesRecord
                                            .img,
                                        width: 139.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20.0, 0.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listviewRestaurantesRestaurantesRecord
                                                .nome,
                                            style: ProjectTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize: 20.0,
                                                ),
                                          ),
                                          Text(
                                            listviewRestaurantesRestaurantesRecord
                                                .desc,
                                            style: ProjectTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(1.00, 0.00),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 10.0, 0.0),
                                          child: Icon(
                                            Icons.keyboard_arrow_right_outlined,
                                            color: ProjectTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
