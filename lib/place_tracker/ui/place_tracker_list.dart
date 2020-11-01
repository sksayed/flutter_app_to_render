import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/place_tracker/app_bloc/appstate_bloc.dart';
import 'package:flutter_app_to_render/place_tracker/domain/place.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceTrackerList extends StatefulWidget {
  @override
  _PlaceTrackerListState createState() => _PlaceTrackerListState();
}

class _PlaceTrackerListState extends State<PlaceTrackerList> {
  AppstateBloc _appstateBloc;
  final ScrollController _scrollController = ScrollController();
  BuildContext _context;

  @override
  void initState() {
    _appstateBloc = BlocProvider.of<AppstateBloc>(context);
    _context = context;
    super.initState();
  }

  void _PlaceCategoryChanged(PlaceCategory placeCategory) {
    _appstateBloc.add(PlaceCategoryChangedEvent(placeCategory));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppstateBloc, AppstateState>(
      builder: (context, state) {
        PlaceCategory category = _appstateBloc.selectedCategory;
        if (state is PlaceCategoryChangedState) {
          category = state.placeCategory;
        }
        if (state is PlaceCategoryInitialState) {
          category = state.placeCategory;
        }
        return Column(
          children: [
            _ListCategoryButtonBar(
              placeCategory: category,
              onCategoryChanged: _PlaceCategoryChanged,
            ),
            Expanded(
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  controller: _scrollController,
                  shrinkWrap: true,
                  children: _appstateBloc.places
                      .where((place) => place.category == category)
                      .map((place) => _PlaceListTile(place: place))
                      .toList()),
            ),
          ],
        );
      },
    );
  }
}

class _ListCategoryButtonBar extends StatelessWidget {
  final PlaceCategory placeCategory;
  final ValueChanged<PlaceCategory> onCategoryChanged;

  const _ListCategoryButtonBar(
      {Key key, @required this.placeCategory, @required this.onCategoryChanged})
      : assert(placeCategory != null),
        assert(onCategoryChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CategoryButton(
            placeCategory: PlaceCategory.visited,
            selected: placeCategory == PlaceCategory.visited,
            onCategoryChanged: onCategoryChanged),
        _CategoryButton(
            placeCategory: PlaceCategory.favorite,
            selected: placeCategory == PlaceCategory.favorite,
            onCategoryChanged: onCategoryChanged),
        _CategoryButton(
            placeCategory: PlaceCategory.wantToGo,
            selected: placeCategory == PlaceCategory.wantToGo,
            onCategoryChanged: onCategoryChanged),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final PlaceCategory placeCategory;
  String btnText;
  final bool selected;
  final ValueChanged<PlaceCategory> onCategoryChanged;

  _CategoryButton(
      {Key key,
      @required this.placeCategory,
      @required this.selected,
      @required this.onCategoryChanged})
      : assert(placeCategory != null),
        assert(selected != null),
        assert(onCategoryChanged != null),
        super(key: key);

  String getBtnText(PlaceCategory placeCategory) {
    String result = " ";
    final cat = placeCategory;
    switch (cat) {
      case PlaceCategory.favorite:
        result = "Favourite";
        break;
      case PlaceCategory.wantToGo:
        result = "Want To Go";
        break;
      case PlaceCategory.visited:
        result = "Visited";
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    this.btnText = getBtnText(placeCategory);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: selected ? Colors.lightBlue : Colors.transparent),
        ),
      ),
      child: ButtonTheme(
        height: 50,
        child: FlatButton(
          child: Text(
            this.btnText,
            style: TextStyle(
              fontSize: selected ? 20 : 18,
              color: selected ? Colors.blue : Colors.black87,
            ),
          ),
          onPressed: () => onCategoryChanged(placeCategory),
        ),
      ),
    );
  }
}

class _PlaceListTile extends StatelessWidget {
  final Place place;

  const _PlaceListTile({Key key, @required this.place})
      : assert(place != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            place.name,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            maxLines: 3,
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 28.0,
                color:
                    place.starRating > index ? Colors.amber : Colors.grey[400],
              );
            }).toList(),
          ),
          Text(
            place.description ?? '',
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.0),
          Divider(
            height: 2.0,
            color: Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
