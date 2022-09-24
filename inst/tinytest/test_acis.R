
# Placeholder with simple test
expect_equal(acis:::.acis_query_string(list(params='{"loc":"-95.36,29.76","sdate":"2012-1","edate":"2012-7","grid":"3","elems":[{"name":"maxt","interval":"mly","duration":"mly","reduce":"max","smry":"max"}]}'), call = "GridData"),
             "http://data.rcc-acis.org/GridData?params=%7B%22loc%22%3A%22-95.36%2C29.76%22%2C%22sdate%22%3A%222012-1%22%2C%22edate%22%3A%222012-7%22%2C%22grid%22%3A%223%22%2C%22elems%22%3A%5B%7B%22name%22%3A%22maxt%22%2C%22interval%22%3A%22mly%22%2C%22duration%22%3A%22mly%22%2C%22reduce%22%3A%22max%22%2C%22smry%22%3A%22max%22%7D%5D%7D")

