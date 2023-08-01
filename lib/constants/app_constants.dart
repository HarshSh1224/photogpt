class AppConstants {
  static String homePageBgImageUrl = 'https://source.unsplash.com/random/?mountain';
  static String appIcon = 'https://freelogopng.com/images/all_img/1681038800chatgpt-logo-black.png';
  static String appLogoWhite = 'https://files.nohat.cc/file-tmp/visualhunter-33fd8316d0.png';
  static String addImageBg = '';

  static String randomImageUrl({String keyword1 = '', String keyword2 = '', String keyword3 = ''}) {
    return 'https://source.unsplash.com/random/?$keyword1,$keyword2,$keyword3';
  }
}
