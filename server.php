<?php

	////конфигурация базы данных MySQL////
	const DB_NAME = "chat_p2p";
	const DB_TABLE = "users";
	const DB_USER_NAME = "root";
	const DB_PASSWORD = "";
	//////////////////////////////////////

//запускаем сессию - чтобы можно было сохранить user_id при первом запросе к серверу
//и затем иметь возможность его использовать при последующих запросах
session_start();

//это вызывается из флеш, путем передачи get-параметра start
//
if(isset($_GET['start']))
{
	//получаем user_id уже существующего пользователя("авторизация" по ip), либо создаем нового (в БД) 
	$_SESSION['user_id']=getUser();

	//генерируем md5-хэш и записываем его в БД как адрес исходящего от нас потока
	generateBroadcasterKey();

	//берем из БД и возвращем флешу сгенерированный в предыдущей функции адрес исходящего потока
	echo getBroadcasterKey();
}


//во флеше нажали "поиск собеседника"
if(isset($_GET['find_companion']))
{
	//если сессия не начата, то возвращаем информацию о неудачной попытке поиска 
	//(во флеш это сейчас не обрабатывается)
	if(empty($_SESSION["user_id"])){
		return "fail";
	}
	//если сессия была успешно начата, то получаем из её массива user_id
	//и используем его для поиска собеседника

	//получаем адреса потоков всех доступных собеседников
	$companion_key = getCompanion( $_SESSION['user_id'] );

	//и отправляем во флеш случайного собеседника из списка
	echo $companion_key[rand(0,count($companion_key)-1)]['key_broadcaster'];
	// var_dump($companion_key);
}



//перед вызовом сессия должна уже быть начата
//этот вызов флеш делает регулярно, чтобы обновить свое время пребывания на сервере
//по этому параметру мы сможем затем судить о том, онлайн ли пользователь или уже нет
if(isset($_GET['update_user_status']))
{
	$id = $_SESSION['user_id'];
	$query = "UPDATE ".DB_TABLE." SET timestamp=".time()." WHERE id=".$id;
	
	mySQLQuery($query);
}



/** получаем собеседника*/
function getCompanion($id)
{
	//получаем список ключей медиа-потоков пользователей, находящихся сейчас онлайн
	$query = "SELECT key_broadcaster FROM ".DB_TABLE." WHERE id!=".$id." AND timestamp>".(string)(time()-5);
	$companion = mySQLQuery($query);
	return $companion;
}


//генерируем ключ для исходящего медиа-потока. Эту функцию вызывает каждый юзер
//функция вызывается каждый раз при подключении пользователя к видео-чату
function generateBroadcasterKey()
{
	$b_key = md5(time());
	$id = $_SESSION['user_id'];

	$query = "UPDATE ".DB_TABLE." SET key_broadcaster='$b_key' WHERE id=$id";
	mySQLQuery($query);

	return $b_key;
}

//получаем свой ключ бродкастера из БД
function getBroadcasterKey()
{
	$id = $_SESSION['user_id'];
	$query = "SELECT key_broadcaster FROM ".DB_TABLE." WHERE id=".$id;
	// var_dump($query);
	$b_key = mySQLQuery($query)[0];

	return $b_key['key_broadcaster'];
}


//тут добавляем нового юзера, либо просто возвращаем ему его id
function getUser()
{
	/* Выполняем SQL-запрос */
	$ip = $_SERVER["REMOTE_ADDR"];//получаем свой ip
	$query = "SELECT * FROM users WHERE ip='$ip'";//формируем запрос к БД
	$data = mySQLQuery($query);//выполняем запрос и получаем ответ

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


//функция для работы с БД
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