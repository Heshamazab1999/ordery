import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController mapController;
  LocationSearchDialog({@required this.mapController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 80),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(width: 1170, child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _controller,
            textInputAction: TextInputAction.search,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: getTranslated('search_location', context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
              ),
              hintStyle: Theme.of(context).textTheme.headline2.copyWith(
                fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).disabledColor,
              ),
              filled: true, fillColor: Theme.of(context).cardColor,
            ),
            style: Theme.of(context).textTheme.headline2.copyWith(
              color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE,
            ),
          ),
          suggestionsCallback: (pattern) async {
            return await Provider.of<LocationProvider>(context, listen: false).searchLocation(context, pattern);
          },
          itemBuilder: (context, Prediction suggestion) {
            return Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Row(children: [
                Icon(Icons.location_on),
                Expanded(
                  child: Text(suggestion.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_LARGE,
                  )),
                ),
              ]),
            );
          },
          onSuggestionSelected: (Prediction suggestion) {
            Provider.of<LocationProvider>(context, listen: false).setLocation(suggestion.placeId, suggestion.description, mapController);
            Navigator.pop(context);
          },
        )),
      ),
    );
  }
}