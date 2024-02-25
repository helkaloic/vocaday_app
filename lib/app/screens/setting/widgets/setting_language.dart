part of '../setting_page.dart';

class _SettingLanguage extends StatelessWidget {
  void _onChangedLanguage(Locale? value, BuildContext context) async {
    if (value != null) {
      context.read<LanguageCubit>().changeLanguage(value);
      await context.setLocale(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTileCustom(
      minHeight: 60.h,
      width: context.screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      leading: const Icon(Icons.language),
      titlePadding: EdgeInsets.symmetric(horizontal: 20.w),
      title: TextCustom(
        LocaleKeys.setting_language.tr(),
        style: context.textStyle.bodyS.bw,
      ),
      trailing: DropdownButton(
        underline: const SizedBox(),
        value: context.locale,
        onChanged: (value) => _onChangedLanguage(value, context),
        elevation: 1,
        items: [
          DropdownMenuItem(
            value: AppLocale.en.instance,
            child: TextCustom(
              LocaleKeys.app_language_english.tr(),
              style: context.textStyle.caption.bw,
            ),
          ),
          DropdownMenuItem(
            value: AppLocale.vi.instance,
            child: TextCustom(
              LocaleKeys.app_language_vietnamese.tr(),
              style: context.textStyle.caption.bw,
            ),
          ),
        ],
      ),
    );
  }
}
