<?php


	////config////
	const DB_NAME = "chat_p2p";
	const DB_TABLE = "users";
	const DB_USER_NAME = "root";
	const DB_PASSWORD = "";
	/////////////

 if(! isset($_SESSION) )session_start();


if(isset($_GET['start']))
{
	$_SESSION['user_id'] = getUser();

	generateBroadcasterKey();

	echo getBroadcasterKey();
}


if(isset($_GET['find_companion']))
{
	echo getCompanion();
}



//перед вызовом сессия должна уже быть начата
if(isset($_GET['update_user_status']))
{
	$id = $_SESSION['user_id'];
	$query = "UPDATE ".DB_TABLE." SET timestamp=".time()." WHERE id=".$id;
	
	mySQLQuery($query);
}

function getCompanion()
{
	$query = "SELECT ip FROM ".DB_TABLE." WHERE id!=".$id;
	$companion = mySQLQuery($query);

	//TODO: здесь сделать отсев по ip из черного списка юзера

	return $companion[rand(0,count($companion)-1)];
}

function generateBroadcasterKey()
{
	$b_key = md5(time());
	$id = $_SESSION['user_id'];
	$query = "UPDATE ".DB_TABLE." SET key_broadcaster='$b_key' WHERE id=$id";
	mySQLQuery($query);

	return $b_key;
}

function getBroadcasterKey()
{
	$id = $_SESSION['user_id'];
	$query = "SELECT key_broadcaster FROM ".DB_TABLE." WHERE id=".$id;
	// var_dump($query);
	$b_key = mySQLQuery($query)[0];

	return $b_key['key_broadcaster'];
}

function getUser()
{
	/* Выполняем SQL-запрос */
	$ip = $_SERVER["REMOTE_ADDR"];

	$query = "SELECT * FROM users WHERE ip='$ip'";
	$data = mySQLQuery($query);

	$user_id;
	//юзер уже есть в базе данных
	if( isset($data[0]['id']) )
	{
		$user_id = $data[0]['id'];
	}

	//если в чат зашел новый пользователь - записываем его в БД
	if( is_null($user_id))
	{
		$timestamp = time();
		$key_broadcaster = 'b_key';
		$key_receiver = 'free';

		$query = "INSERT INTO users(timestamp,key_broadcaster,key_receiver,ip)
				VALUES('$timestamp','$key_broadcaster','$key_receiver','$ip')";
		
		$data = mySQLQuery($query);
		$user_id = $data[0]['id'];
	}

	return $user_id;
}

function mySQLQuery($query_string)
{
	/* Соединяемся, выбираем базу данных */
	$link = mysql_connect("localhost", DB_USER_NAME, DB_PASSWORD)
	or die("Could not connect : " . mysql_error());
	mysql_select_db(DB_NAME) or die("Could not select database");
	$result = mysql_query($query_string) or die("Query failed : " . mysql_error());
	
	$data = array();
	try
	{
		while($line = @mysql_fetch_array($result,MYSQL_ASSOC))
		{
			$data[] = $line;
		}
	}
	catch(Exception $e){}
	return $data;
}
?>