enum NavBtn {
  navFirst,
  navPrior,
  navNext,
  navLast,
  navAdd,
  navRemove,
  navEdit,
  navSave,
  navCancel,
  navRefresh,
  navCustom1,
  navCustom2,
}

const List<NavBtn> completeNavBtn = [
  NavBtn.navFirst,
  NavBtn.navPrior,
  NavBtn.navNext,
  NavBtn.navLast,
  NavBtn.navAdd,
  NavBtn.navRemove,
  NavBtn.navEdit,
  NavBtn.navSave,
  NavBtn.navCancel,
  NavBtn.navRefresh,
];

const List<NavBtn> moveNavBtn = [NavBtn.navFirst, NavBtn.navPrior, NavBtn.navNext, NavBtn.navLast];

const List<NavBtn> moveAndCustomBtn = [
  NavBtn.navFirst,
  NavBtn.navPrior,
  NavBtn.navNext,
  NavBtn.navLast,
  NavBtn.navCustom1,
];

const List<NavBtn> dataNavBtn = [
  NavBtn.navAdd,
  NavBtn.navRemove,
  NavBtn.navEdit,
  NavBtn.navSave,
  NavBtn.navCancel,
  NavBtn.navRefresh,
];

const List<NavBtn> gridNavBtn = [
  NavBtn.navFirst,
  NavBtn.navPrior,
  NavBtn.navNext,
  NavBtn.navLast,
  NavBtn.navAdd,
  NavBtn.navRemove,
  NavBtn.navEdit,
  NavBtn.navRefresh,
];

const minWidth = 550;
const hideWidth = 360;
