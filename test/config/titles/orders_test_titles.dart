class OrdersTestTitles {
  String REPO_NAME = 'OrdersMockedRepo';

  // @formatter:off
  //GROUP-TITLES ---------------------------------------------------------------
  static get ORDERS_GROUP_TITLE => 'Orders|Integration-Tests:';

  //MVC-TITLES -----------------------------------------------------------------
  get REPO_TEST_TITLE => '$REPO_NAME|Repo: Unit';
  get SERVICE_TEST_TITLE => '$REPO_NAME|Service: Unit';
  get CONTROLLER_TEST_TITLE => '$REPO_NAME|Controller: Integr';
  get VIEW_TEST_TITLE => '$REPO_NAME|View: Functional';

  //TEST-TITLES ----------------------------------------------------------------
  get check_emptyView_noOrderInDb => 'Empty View - No Orders in DB';
  get check_orders_with_one_orderInDB => 'Opening View with One ORDER in DB';
  get tap_viewBackButton => 'Testing View BackButton';
  get orderingAProduct_inCartView_tapping_OrderNowButton =>
      'Ordering from CartView - Taping OrderNow Button';
  // @formatter:on
}
