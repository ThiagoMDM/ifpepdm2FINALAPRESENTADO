import '/backend/backend.dart';
import '../conf_project/my_icon_button.dart';
import '../conf_project/my_theme.dart';
import '../conf_project/util.dart';
import '../conf_project/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detalhesprod_model.dart';
export 'detalhesprod_model.dart';

class DetalhesprodWidget extends StatefulWidget {
  const DetalhesprodWidget({
    Key? key,
    required this.refprodutos,
  }) : super(key: key);

  final DocumentReference? refprodutos;

  @override
  _DetalhesprodWidgetState createState() => _DetalhesprodWidgetState();
}

class _DetalhesprodWidgetState extends State<DetalhesprodWidget> {
  late DetalhesprodModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesprodModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();

    return StreamBuilder<PratosRecord>(
      stream: PratosRecord.getDocument(widget.refprodutos!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFF705FFF),
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ProjectTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        final detalhesprodPratosRecord = snapshot.data!;
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFF705FFF),
            appBar: AppBar(
              backgroundColor: ProjectTheme.of(context).primary,
              automaticallyImplyLeading: true,
              title: Text(
                detalhesprodPratosRecord.nome,
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
                    color: ProjectTheme.of(context).info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(
                      'carrinho',
                      queryParameters: {
                        'refrestaurantes': serializeParam(
                          detalhesprodPratosRecord.parentReference,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Container(
                        width: 400.0,
                        height: 403.0,
                        decoration: BoxDecoration(
                          color: ProjectTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              detalhesprodPratosRecord.img,
                              width: 300.0,
                              height: 0.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.00, 0.00),
                      child: Text(
                        detalhesprodPratosRecord.nome,
                        style: ProjectTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: ProjectTheme.of(context).info,
                              fontSize: 25.0,
                            ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          detalhesprodPratosRecord.desc,
                          style: ProjectTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',
                                color: ProjectTheme.of(context).info,
                              ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(1.00, 0.00),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                        child: Text(
                          'R\$${formatNumber(
                            detalhesprodPratosRecord.preco,
                            formatType: FormatType.decimal,
                            decimalType: DecimalType.automatic,
                          )}',
                          style: ProjectTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',
                                color: ProjectTheme.of(context).info,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    ButtonWidget(
                      onPressed: () async {
                        setState(() {
                          AppState().addToCarrinho(
                              detalhesprodPratosRecord.reference);
                        });
                        setState(() {
                          AppState().somaCarrinho = AppState().somaCarrinho +
                              detalhesprodPratosRecord.preco;
                        });
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Item Adicionado ao Carrinho'),
                              content: Text('Sucesso!'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext),
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      text: 'Add Carrinho',
                      options: ButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFF00F16F),
                        textStyle: ProjectTheme.of(context).titleSmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                            ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
