import 'package:flutter/material.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/routing.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/modal_route.dart';

class MoreOptionsPopupMenu extends StatelessWidget{
  MoreOptionsPopupMenu({@required this.idFieldValue, @required this.detailRouteName, @required this.editRouteName, @required this.deleteWhat});

  final int idFieldValue;
  final String detailRouteName;
  final String editRouteName;
  final String deleteWhat;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: ThemeColors.card,
      ),
      child: PopupMenuButton<int>(
        elevation: 4,
        icon: Icon(Icons.more_vert, color: ThemeColors.mainText,),
        onSelected: (value) {
          switch(value){
            case 1:
              Routing.navigateTo(context, "$detailRouteName/$idFieldValue");
              break;
            case 2:
              Routing.navigateTo(context, "$editRouteName/$idFieldValue");
              break;
            case 3:
              ModalPopup(
                title: "Delete $deleteWhat",
                buildContext: context,
                contents: Container(
                  child: Row(
                    children: <Widget>[
                      ModalPopupDismissOption(
                        appScaffoldBottomAppBarTab: AppScaffoldBottomAppBarTab(text: 'Delete', icon: Icons.delete_forever),
                        onTapFunc: () {
                          print('deleting at some point');
                          Navigator.pop(context);
                        }
                      ),
                      ModalPopupDismissOption(
                        appScaffoldBottomAppBarTab: AppScaffoldBottomAppBarTab(text: 'Cancel', icon: Icons.cancel),
                        onTapFunc: () {
                          print('cancelling the delete');
                          Navigator.pop(context);
                        }
                      )
                    ],
                  ),
                )
              );
          }
        },
        itemBuilder: (context) => [
          ModalPopupMenuOptions.modalPopupMenuOption(value: 1, iconData: Icons.details, label: 'details',),
          PopupMenuDivider(height: 3),
          ModalPopupMenuOptions.modalPopupMenuOption(value: 2, iconData: Icons.edit, label: 'edit',),
          PopupMenuDivider(height: 3),
          ModalPopupMenuOptions.modalPopupMenuOption(value: 3, iconData: Icons.delete_forever, label: 'delete',),
        ]
      ),
    );
  }
}