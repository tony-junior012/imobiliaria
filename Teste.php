<?php
require_once 'db_test.php';

class Alberto_teste
{
    public $name;
    public $age;
    public $city;

}

$myObj = new Alberto_teste;

$myObj->name = "John";
$myObj->age = 30;
$myObj->city = "New York";

$myJSON = json_encode($myObj);
        
        $sql = "insert into test_json(Arquivo_json) values('{$myJSON}') ";
        //retorna a consulta para a variavel login
        mysqli_query($conexao, $sql);

        echo $myJSON;
           
        
?>