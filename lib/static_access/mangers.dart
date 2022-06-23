import '../models/user_model.dart';
import '../screens/chat_screen/chat_manger.dart';
import '../screens/home_screen/home_manger.dart';
import '../screens/profile_screen/profile_manger.dart';
import '../screens/setting/setting_manger.dart';

class StaticManger {
  static HomeManger? homeManger;
  static ProfileManger? profileManger;
  static UserModel? userModel;
  static SettingManger? settingManger;
  static ChatManger? chatManger;
}
