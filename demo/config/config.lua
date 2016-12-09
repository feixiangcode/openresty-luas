local config = {
    redis = {
		host = '172.16.21.22',
    	port = '6379'
	},
	mysql = {
		host = '127.0.0.1',
    	port = 3306,
    	user = 'root',
    	password = '123456',
    	database = 'blog'
	}
}
return config