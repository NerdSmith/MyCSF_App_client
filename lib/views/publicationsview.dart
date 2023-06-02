import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycsf_app_client/api/publication.dart';
import 'package:mycsf_app_client/views/mypublicationview.dart';

class PublicationsView extends StatefulWidget {
  const PublicationsView({Key? key}) : super(key: key);

  @override
  State<PublicationsView> createState() => _PublicationsViewState();
}

class _PublicationsViewState extends State<PublicationsView> {
  final PublicationBloc _publicationBloc = PublicationBloc();
  ScrollController _scrollController = ScrollController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _publicationBloc.fetchPubs();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _publicationBloc.close();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
      if (!_isFetching) {
        _isFetching = true;
        _publicationBloc.fetchPubs().then((_) {
          _isFetching = false;
        });
      }
    }
  }

  void openPabPage(Publication pub) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPublicationView(publication: pub),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        Expanded(
            child: BlocBuilder<PublicationBloc, List<Publication>>(
                bloc: _publicationBloc,
                builder: (context, pubList) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: pubList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < pubList.length) {
                        final pubs = pubList[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 20, top: 0, right: 20, bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              openPabPage(pubs);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  if (pubs.image != null)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, right: 20, left: 20),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          child: CachedNetworkImage(
                                            imageUrl: pubs.image!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                                  child: CircularProgressIndicator(
                                                    color: Color(0xFFD9D9D9),
                                                  ),
                                                ),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          )),
                                    ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
                                        child: Text(
                                          pubs.title!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      )
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 20, bottom: 5),
                                      child: Text(
                                        pubs.getDatetimeRepr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        );
                      }
                      else {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator(
                            color: Color(0xFFD9D9D9),
                          )),
                        );
                      }
                    },
                  );
                }
                )
        )
      ],
    );
  }
}
