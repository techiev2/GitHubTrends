mostWatchedRepos = dbGetQuery(con,statement='SELECT repo_url,repo_watchers,repo_forks,repo_stargazers from AllEvents GROUP BY repo_url ORDER BY repo_watchers DESC LIMIT 10')

for(i in 1 : length(mostWatchedRepos$repo_url)) {
	sql = cbind("SELECT timeStamp,repo_watchers FROM AllEvents WHERE repo_url = '", mostWatchedRepos$repo_url[i],"' ORDER BY timeStamp")
	print(sql)	
	growthData = dbGetQuery(con,statement=paste(sql[1,], collapse = ""))
	growthData$timeStamp = strptime(growthData$timeStamp,"%Y-%m-%dT%H:%M:%S")
	#filename = cbind( mostWatchedRepos$repo_url[i],".jpg")
	repoName = str_replace_all(mostWatchedRepos$repo_url[i],"/","")
	repoName = str_replace_all(repoName,":","")
	repoName = str_replace(repoName,'httpsgithub.com','')
	filename = cbind( "/home/kira/GitHubTrends/plotImagesByR/",repoName,".jpg")
	file.create(paste(filename[1,], collapse = ""))	
	jpeg(paste(filename[1,], collapse = ""))
	plot(growthData$timeStamp,growthData$repo_watchers)
	scatter.smooth(growthData$timeStamp,growthData$repo_watchers,col="red")
	#plot(growthData$repo_watchers ~ growthData$timeStamp, col = "blue")
	#with(cars, lines(loess.smooth(growthData$timeStamp, growthData$repo_watchers), col = "green"))
	title(main=mostWatchedRepos$repo_url[i])
	dev.off()
    
}

