# RHRefresh

swift 上拉刷新和下拉加载，简单易用。

下拉刷新用法
``` swift
  let header = RHRefreshHeader(refreshScrollView: tableView)
  header.refreshHandler = {
    doSomeThing()
    header.endRefresh()
  }
  header.beginRefresh()
``` 

上拉加载用法
``` swift
  let footer = RHRefreshFooter(refreshScrollView: tableView)
  footer.refreshHandler = {
    doSomeThing()
    footer.endRefresh()
   }
``` 
