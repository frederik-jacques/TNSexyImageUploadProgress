<?php 

$result_json = array();

// headers for not caching the results
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');

// headers to tell that result is JSON
header('Content-type: application/json');


if ( !isset($_FILES['upfile']['error']) ||
	 is_array($_FILES['upfile']['error'])
    ) {        
	$result_json['error'] = 'Invalid parameter';
}else{
	$result_json['error'] = false;
}

switch ($_FILES['upfile']['error']) {
		case UPLOAD_ERR_OK:
		break;

		case UPLOAD_ERR_NO_FILE:
			$result_json['error'] = 'No file sent';

		case UPLOAD_ERR_INI_SIZE:
		case UPLOAD_ERR_FORM_SIZE:
			$result_json['error'] = 'Exceeded filesize';
		
		default:
	        $result_json['error'] = 'Unknown error';
}

if ($_FILES['upfile']['size'] > 100000000) {
	$result_json['error'] = 'Exceeded filesize';
}

$finfo = new finfo(FILEINFO_MIME_TYPE);

if (false === $ext = array_search(
	$finfo->file($_FILES['upfile']['tmp_name']),
    	array(        	
            'png' => 'image/png'           
        ),
        true
    )) {
        $result_json['error'] = 'Invalid file format';
}

if (!move_uploaded_file(
    $_FILES['upfile']['tmp_name'],
    sprintf('./uploads/%s.%s',
    	sha1_file($_FILES['upfile']['tmp_name']),
    	$ext
    )
    )) {
        $result_json['error'] = 'Failed to move uploaded file';
}

// send the result now
echo json_encode($result_json);

/*
try {

	if (!move_uploaded_file(
	    $_FILES['upfile']['tmp_name'],
	    sprintf('./uploads/%s.%s',
	    	sha1_file($_FILES['upfile']['tmp_name']),
	    	$ext
	    )
	    )) {
	        //throw new RuntimeException('Failed to move uploaded file.');
	}

	//echo json_encode(array('succes'=>true));
} catch (RuntimeException $e) {

    //echo $e->getMessage();

}
*/
?>