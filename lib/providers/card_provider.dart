import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/user_app_pages/property_information_pages/home_details_page.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';

import '../models/complement_models/filters_model.dart';
import '../models/residence_model.dart';
import '../models/user_model.dart';
import '../preferences/filter_preference.dart';
import '../preferences/user_preference.dart';
import '../services/firebase/residences_crud.dart';
import '../services/firebase/user_crud.dart';

enum CardStatus { like, dislike, goDetailsResidence }

class CardProvider extends ChangeNotifier {
  List<ResidenceModel> _residences = [];
  List<ResidenceModel> residencesComplete = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  FiltersModel filters = FiltersModel();

  List<ResidenceModel> get residences => _residences;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  CardProvider() {
    resetResidences();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition(DragEndDetails details, UserProvider provider,
      ResidenceModel residenceModel, BuildContext context) {
    UserModel user = UserModel();
    user = provider.user;
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    if (status != null) {
      Fluttertoast.cancel();
    }

    switch (status) {
      case CardStatus.like:
        if (user.email != null) {
          if (!user.userLikes!.contains(residenceModel.id)) {
            user.userLikes!.add(residenceModel.id!);
            provider.setUser(user);
            UserCrud().updateUser(user.id!, user);
            UserPreferences().saveData(user);
          }
          like();
        } else {
          resetPosition();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyUser(
                  user: user,
                ),
              ),
              (_) => false);
        }

        break;
      case CardStatus.dislike:
        dislike();
        break;

      case CardStatus.goDetailsResidence:
        goDetailsResidence(residenceModel, context);
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  Future<void> resetResidences() async {
    _residences = [];
    filters = await FilterPreference().loadData();
    residencesComplete =
        await ResidenceCrud().getResidencesOfStateInApp('Publicada');
    bool filtersIsApplied = checkFilter(filters);
    if (filtersIsApplied) {
      _residences = applyFilters(residencesComplete, filters);
    } else {
      _residences = residencesComplete;
    }

    notifyListeners();
  }

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceDetails = x.abs() < 20;
    if (force) {
      const delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceDetails) {
        return CardStatus.goDetailsResidence;
      }
    } else {
      const delta = 20;
      if (y <= -delta * 2 && forceDetails) {
        return CardStatus.goDetailsResidence;
      } else if (x >= delta) {
        return CardStatus.like;
      } else if (y <= -delta) {
        return CardStatus.dislike;
      }
    }
    return null;
  }

  Future _nextCard() async {
    if (_residences.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    _residences.removeLast();
    resetPosition();
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void goDetailsResidence(
      ResidenceModel residenceModel, BuildContext context) async {
    _angle = 0;
    _position = Offset(0, _screenSize.height);
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              HomeDetails(residence: residenceModel),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
        (_) => false);

    resetPosition();
  }

  bool checkFilter(FiltersModel filters) {
    if (filters.availibity!.isNotEmpty ||
        filters.stateOfResidence!.isNotEmpty ||
        filters.typeOfResidence!.isNotEmpty ||
        filters.typeOfAuction!.isNotEmpty ||
        filters.bath != 0 ||
        filters.room != 0 ||
        filters.garage != 0 ||
        filters.minPrice != 0 ||
        filters.maxPrice != 0 ||
        filters.city != '') {
      return true;
    } else {
      return false;
    }
  }

  List<ResidenceModel> applyFilters(
      List<ResidenceModel> residencesComplete, FiltersModel filters) {
    List<ResidenceModel> newList = [];
    for (var i = 0; i < residencesComplete.length; i++) {
      for (var j = 0; j < filters.availibity!.length; j++) {
        if (residencesComplete[i]
            .availability!
            .contains(filters.availibity![j])) {
          if (!newList.contains(residencesComplete[i])) {
            newList.add(residencesComplete[i]);
          }
        }
      }

      if (filters.typeOfAuction!
          .contains(residencesComplete[i].typeOfAuction)) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }
      if (filters.stateOfResidence!.contains(residencesComplete[i].state)) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }
      if (filters.typeOfResidence!
          .contains(residencesComplete[i].typeOfResidence)) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }
      if (filters.bath == residencesComplete[i].bath) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }
      if (filters.garage == residencesComplete[i].garage) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }
      if (filters.room == residencesComplete[i].room) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }
      if (residencesComplete[i].baseAuctionPrice! <= filters.maxPrice! &&
          filters.maxPrice != 0) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }
      if (residencesComplete[i].baseAuctionPrice! >= filters.minPrice! &&
          filters.minPrice != 0) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }
      if (filters.city! == residencesComplete[i].city!) {
        if (!newList.contains(residencesComplete[i])) {
          newList.add(residencesComplete[i]);
        }
      }

      if (i == residencesComplete.length && newList.isEmpty) {
        newList = residencesComplete;
      }
    }
    return newList;
  }
}
