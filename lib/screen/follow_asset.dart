import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

import '../config.dart' as config;
import '../backend.dart' as backend;
import '../widget.dart';
import '../model.dart';

enum _Option {
  recommended,
  scanQRCode,
  search,
  myHoldings,
  assetId,
}

class FollowAssetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Follow Asset')),
      body: FollowAssetScreenBody(),
    );
  }
}

class FollowAssetScreenBody extends StatefulWidget {
  @override
  _FollowAssetScreenBodyState createState() => _FollowAssetScreenBodyState();
}

class _FollowAssetScreenBodyState extends State<FollowAssetScreenBody> {
  var selectedOption = _Option.recommended;

  Widget option({
    @required String title,
    @required _Option value,
  }) =>
      RadioListTile(
        title: Text(title),
        value: value,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value;
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          option(
            title: 'Recommended',
            value: _Option.recommended,
          ),
          option(
            title: 'Scan QR Code',
            value: _Option.scanQRCode,
          ),
          option(
            title: 'Search',
            value: _Option.search,
          ),
          option(
            title: 'My Holdings',
            value: _Option.myHoldings,
          ),
          option(
            title: 'Asset ID',
            value: _Option.assetId,
          ),
          Gap(20),
          Expanded(
            child: OptionRenderer(
              option: selectedOption,
            ),
          )
        ],
      ),
    );
  }
}

class OptionRenderer extends StatelessWidget {
  final _Option option;

  const OptionRenderer({Key key, this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (option) {
      case _Option.recommended:
        return _Recommended();
      case _Option.scanQRCode:
        return _ScanQRCode();
      case _Option.search:
        return _Search();
      case _Option.myHoldings:
        return _MyHoldings();
      case _Option.assetId:
        return _AssetID();
    }

    throw Exception("No renderer for $option");
  }
}

class _Recommended extends StatefulWidget {
  @override
  __RecommendedState createState() => __RecommendedState();
}

class __RecommendedState extends State<_Recommended> {
  var isLoading = true;

  var assets = [];

  void initState() {
    super.initState();

    backend.queryAssets(config.convexityAddress).then((assets) {
      // It's important to check if the Widget is mounted
      // because the user might change the selected option
      // while we're still loading the recommended Assets.
      if (mounted) {
        setState(
          () {
            this.isLoading = false;
            this.assets = assets;
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var following = context.watch<AppState>().model.following;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        children: assets
            .map(
              (token) => Stack(
                children: [
                  TokenRenderer(
                    token: token,
                    onTap: (token) {
                      var followingCopy = Set<Token>.from(following);

                      if (followingCopy.contains(token)) {
                        followingCopy.remove(token);
                      } else {
                        followingCopy.add(token);
                      }

                      context.read<AppState>().setFollowing(
                            followingCopy,
                            shouldPersist: true,
                          );
                    },
                  ),
                  if (following.contains(token))
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    )
                ],
              ),
            )
            .toList(),
      );
    }
  }
}

class _ScanQRCode extends StatelessWidget {
  void scan() async {
    BarcodeScanner.scan();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QrImage(
          data: 'Convexity',
          version: QrVersions.auto,
          size: 160,
        ),
        ElevatedButton(
          child: Text('Scan QR Code'),
          onPressed: () {
            scan();
          },
        ),
      ],
    );
  }
}

class _Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search'),
    );
  }
}

class _MyHoldings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('My Holdings'),
    );
  }
}

class _AssetID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Asset ID'),
    );
  }
}
