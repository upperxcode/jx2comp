enum AppThemeMode {
  light,
  dark,
  custom,
  purple;

  @override
  toString() {
    return name;
  }
}

enum JxColor {
  primary,
  secondary,
  tertiary,
  page, // Cor de fundo e texto principal da página
  link,
  linkHover,
  linkVisited,
  separatorBorder,
  header, // Cor de fundo e texto principal do cabeçalho
  headerTitleText, // Cor específica para o título do cabeçalho (se diferente do texto principal)
  headerNavigationItem, // Cor do item de navegação do cabeçalho
  headerNavigationItemHover,
  headerNavigationItemActive,
  sidebar, // Cor de fundo e texto principal da barra lateral
  sidebarMenuItem, // Cor do item de menu da barra lateral
  sidebarMenuItemHover,
  sidebarMenuItemActive,
  sidebarMenuItemSelected,
  sidebarSubmenu, // Cor de fundo e texto principal do submenu da barra lateral
  sidebarSubmenuText, // Cor específica para o texto do submenu (se diferente do texto principal)
  content, // Cor de fundo e texto principal do conteúdo
  contentTitleH1,
  contentTitleH2,
  contentTitleH3,
  contentParagraph,
  contentListText,
  contentListMarker,
  contentQuote, // Cor de fundo e texto principal da citação
  contentQuoteBorder,
  contentQuoteText,
  contentCode, // Cor de fundo e texto principal do código
  contentCodeText,
  contentTableBorder,
  contentTableHeader, // Cor de fundo e texto principal do cabeçalho da tabela
  contentTableHeaderText, // Cor específica para o texto do cabeçalho da tabela
  contentTableBodyText, // Cor específica para o texto do corpo da tabela
  contentTableAlternatingRow, // Cor de fundo e texto principal da linha alternada da tabela
  form, // Cor de fundo e texto principal do formulário
  formLabelText,
  formField, // Cor de fundo e texto principal do campo do formulário
  formFieldText, // Cor específica para o texto dentro do campo do formulário
  formFieldBorder,
  formFieldFocus, // Cor de fundo e texto principal do foco do campo do formulário
  formFieldFocusBorder,
  formFieldErrorBorder,
  formFieldSuccessBorder,
  formPlaceholderText,
  formDropdownArrow,
  formButton, // Cor de fundo e texto principal do botão do formulário
  formButtonText, // Cor específica para o texto do botão do formulário
  formButtonHover,
  formButtonActive,
  formButtonDisabled,
  formButtonDisabledText,
  formErrorText,
  formSuccessText,
  footer, // Cor de fundo e texto principal do rodapé
  footerText,
  alertInformation, // Cor de fundo e texto principal do alerta de informação
  alertInformationText,
  alertWarning, // Cor de fundo e texto principal do alerta de aviso
  alertWarningText,
  alertError, // Cor de fundo e texto principal do alerta de erro
  alertErrorText,
  alertSuccess, // Cor de fundo e texto principal do alerta de sucesso
  alertSuccessText,
  progressBar, // Cor de fundo da barra de progresso
  progressBarColor,
  modal, // Cor de fundo e texto principal do modal
  modalContent, // Cor de fundo e texto principal do conteúdo do modal
  modalBorder,
  modalText,
  iconColorDefault,
  warning,
  submit,
  confirm,
  face,
  formTextFace,
  formTextFont,
  formTextFontFloat,
  formTextIcon,
  formTextFocus,
  formTextHover,
  panel,
  menu,
  menuItem,
  menuSubitem,
  grid,
  gridBorder,
  gridAlternatingBackground,
  gridFocus,
  gridSelection,
  gridText,
  gridEven,
  gridOdd,
  gridChecked,
  dbNav,
  dbNavAdd,
  dbNavRemove,
  dbNavEdit,
  dbNavRefresh,
  dbNavSave,
  dbNavCancel;

  @override
  String toString() {
    return name;
  }
}
