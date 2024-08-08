extends Control

var zip_name = 'Javidis-Adventure.zip'
var folder_name = 'Javidis-Adventure'
var folder_path = 'user://Javidis-Adventure'
var executable_name = "Javidis-Adventure.exe"
var release_url = 'https://api.github.com/repos/IGDA-Academic-Charlotte/Javidi-s-Adventures-CPCC/releases/latest'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var download_size = 0
	var currently_downloaded = 0
	if $Downloader.get_body_size() != -1:
		download_size = $Downloader.get_body_size()
		currently_downloaded = $Downloader.get_downloaded_bytes()
		$Panel/ProgressBar.value = currently_downloaded * 100 / download_size
		

func on_download_button_pressed():
	DirAccess.remove_absolute('user://' + zip_name)
	OS.move_to_trash(ProjectSettings.globalize_path(folder_path))
	$Panel/StatusLabel.text = "Downloading..."
	$DownloadLocator.request(release_url)

func _on_download_link_retrieved(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var download_url = json["assets"][0]["browser_download_url"]
	print(download_url)
	zip_name = json["assets"][0]["name"]
	$Downloader.download_file = "user://" + zip_name
	$Downloader.request(download_url)

func _on_download_completed(result, response_code, headers, body):
	$Panel/StatusLabel.text = 'Unzipping...'
	$UnzipTimer.start()


func on_openFilesButton_pressed():
	OS.shell_open(OS.get_user_data_dir());


func _on_unzip_timer_timeout():
	var user_dir = OS.get_user_data_dir()
	var zip_dir = '\'' + user_dir + '/' + zip_name + '\''
	var new_dir = '\'' + user_dir + '/' + folder_name + '\''
	OS.execute("powershell", ['Expand-Archive', zip_dir, '-DestinationPath', new_dir])
	$Panel/StatusLabel.text = 'Finished!'

func play_game():
	OS.shell_open(ProjectSettings.globalize_path(folder_path) + "\\" + executable_name)


func _on_play_game_button_pressed():
	play_game()
