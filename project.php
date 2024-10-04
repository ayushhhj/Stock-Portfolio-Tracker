
<!-- Test Oracle file for UBC CPSC304
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  Modified by Jason Hall (23-09-20)
  This file shows the very basics of how to execute PHP commands on Oracle.
  Specifically, it will drop a table, create a table, insert values update
  values, and then query for values
  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up All OCI commands are
  commands to the Oracle libraries. To get the file to work, you must place it
  somewhere where your Apache server can run it, and you must rename it to have
  a ".php" extension. You must also change the username and password on the
  oci_connect below to be your ORACLE username and password
-->

<?php
// The preceding tag tells the web server to parse the following text as PHP
// rather than HTML (the default)

// The following 3 lines allow PHP errors to be displayed along with the page
// content. Delete or comment out this block when it's no longer needed.
// ini_set('display_errors', 1);
// ini_set('display_startup_errors', 1);
// error_reporting(E_ALL);

// The next tag tells the web server to stop parsing the text as PHP. Use the
// pair of tags wherever the content switches to PHP
?>

<html>
    <head>
        <title>CPSC 304 Financial Porfolio Project</title>
    </head>

    <body>
        <h1> CPSC 304 Financial Portfolio Database Demo </h1>
		<div>

        <h2>Result:</h2>
		<?php
		handle();
		?>
		<hr/>

        <h2>Insertion</h2>
        <p>Create a new account</p>
        <form method="POST" action="project.php">
            <input type="hidden" id="insertAccountRequest" name="insertAccountRequest">
            SIN: <input type="text" name="accountSIN"> <br /><br />
            Full Name: <input type="text" name="accountFullName"> <br /><br />
            Initial Balance: <input type="text" name="accountBalance"> <br /><br />
            Password: <input type="password" name="accountPassword"> <br /><br />
            <input type="submit" value="Create Account" name="createAccountSubmit"></p>
        </form>
        <hr />
		    </div>

        <h2>Stock Removal</h2>
        <p>Remove a stock entry from the database</p>
        <form method="POST" action="project.php">
            <input type="hidden" id="deleteStockRequest" name="deleteStockRequest">
            Investment ID of Stock to Remove: <input type="text" name="deleteStockID"> <br /><br />
            <input type="submit" value="Remove Stock" name="removeStockSubmit"></p>
        </form>
        <hr />  

        <h2>Update Account Balance</h2>
        <p>Update the balance for an existing account</p>
        <form method="POST" action="project.php">
            <input type="hidden" id="updateBalanceRequest" name="updateBalanceRequest">
            SIN of Account: <input type="text" name="updateSin" required> <br /><br />
            New Balance: <input type="number" name="updateBalance" step="0.01" required> <br /><br />
            <input type="submit" value="Update Balance" name="updateBalanceSubmit">
        </form>
        <hr />

        <h2>View Distinct Investment Industries</h2>
        <p>View all unique industries represented in our investments.</p>
        <form method="GET" action="project.php">
            <input type="hidden" id="distinctIndustriesRequest" name="distinctIndustriesRequest">
            <input type="submit" value="View Industries" name="viewIndustriesSubmit">
        </form>
        <hr />
 

        <h2>Find Accounts with High Balance</h2>
        <p>View all high balance accounts.</p>
        <form method="GET", action="project.php">
            <input type="hidden" id="highBalanceAccounts" name="highBalanceRequest">
            <input type="submit" value="Find High Balance Accounts" name="submitHighBalance">
        </form>

       <hr />

        <h2>Investments by Account</h2>
        <form method="GET", action="project.php">
            <input type="hidden" id="joinQueryRequest" name="joinQueryRequest">
            SIN: <input type="text" name="sinJoin"> <br /><br />
            <input type="submit" name="joinInvestments" value="Find Investments">
        </form>
        <hr />

        <h2>Total Investments by Industry</h2>
        <form method="GET", action="project.php">
            <input type="hidden" id="aggregationRequest" name="aggregationRequest">
            <input type="submit" name="aggregateInvestments" value="Aggregate Investments">
        </form>
        <hr />

        <h2>Industries with Total Investments Exceeding 5</h2>
        <form method="GET", action="project.php">
            <input type="hidden" id="aggregationRequest2" name="aggregationRequest2">
            <input type="submit" name="aggregateInvestments2" value="Aggregate Investments 2">
        </form>
        <hr />

        <h2>Maximum Average Quantity by Industry</h2>
        <form method="GET", action="project.php">
            <input type="hidden" id="nestedAggregationRequest" name="nestedAggregationRequest">
            <input type="submit" name="nestedAggregationSubmit" value="Find Max Avg Quantity">
        </form>
        <hr />

        <h2>Accounts Investing in Both Specified Industries</h2>
        <form method="GET", action="project.php">
            <input type="hidden" id="divisionRequest" name="divisionRequest">
            Industry 1: <input type="text" name="industry1" required> <br /><br />
            Industry 2: <input type="text" name="industry2" required> <br /><br />
            <input type="submit" name="divisionSubmit" value="Find Accounts">
        </form>
        <hr />

        <?php
		//this tells the system that it's no longer just parsing html; it's now parsing PHP

        // Database access configuration
        $config["dbuser"] = "ora_ayush21";			// change "cwl" to your own CWL
        $config["dbpassword"] = "a20443560";	// change to 'a' + your student number
        $config["dbserver"] = "dbhost.students.cs.ubc.ca:1522/stu";
        $success = True; //keep track of errors so it redirects the page only if there are no errors
        $db_conn = NULL; // edit the login credentials in connectToDB()
        $show_debug_alert_messages = TRUE; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

        function debugAlertMessage($message) {
            global $show_debug_alert_messages;

            if ($show_debug_alert_messages) {
                echo "<script type='text/javascript'>alert('" . $message . "');</script>";
            }
        }

        function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
            //echo "<br>running ".$cmdstr."<br>";
            global $db_conn, $success;

            $statement = OCIParse($db_conn, $cmdstr);
            // There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
                echo htmlentities($e['message']);
                $success = False;
            }

            $r = OCIExecute($statement, OCI_DEFAULT);
            if (!$r) {
                echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
                echo htmlentities($e['message']);
                $success = False;
            }

			return $statement;
		}

        function executeBoundSQL($cmdstr, $list) {
            /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
		    In this case you don't need to create the statement several times. Bound variables cause a statement to only be 
            parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
		    See the sample code below for how this function is used */

			global $db_conn, $success;
			$statement = OCIParse($db_conn, $cmdstr);

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn);
                echo htmlentities($e['message']);
                $success = False;
            }

            foreach ($list as $tuple) {
                foreach ($tuple as $bind => $val) {
                    //echo $val;
                    //echo "<br>".$bind."<br>";
                    OCIBindByName($statement, $bind, $val);
                    unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
				}

                $r = OCIExecute($statement, OCI_DEFAULT);
                if (!$r) {
                    echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                    $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
                    echo htmlentities($e['message']);
                    echo "<br>";
                    $success = False;
                }
            }
        }

        function printResult($result) { //prints results from a select statement
            echo "<br>Retrieved data from table demoTable:<br>";
            echo "<table>";
            echo "<tr><th>ID</th><th>Name</th></tr>";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["ID"] . "</td><td>" . $row["NAME"] . "</td></tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
        }

        function connectToDB() {
            global $db_conn;

            // Your username is ora_(CWL_ID) and the password is a(student number). For example,
			// ora_platypus is the username and a12345678 is the password.
            $db_conn = OCILogon("ora_ayush21", "a20443560", "dbhost.students.cs.ubc.ca:1522/stu");

            if ($db_conn) {
                debugAlertMessage("Database is Connected");
                return true;
            } else {
                debugAlertMessage("Cannot connect to Database");
                $e = OCI_Error(); // For OCILogon errors pass no handle
                echo htmlentities($e['message']);
                return false;
            }
        }

        function disconnectFromDB() {
            global $db_conn;

            debugAlertMessage("Disconnect from Database");
            OCILogoff($db_conn);
        }


		// QUERY FUNCTIONS

        function printInsertRequestResult() {
            $result = executePlainSQL("SELECT * FROM Accounts");
            echo "<br>Retrieved data from Accounts table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>SIN</th>
					<th>fullName</th>
					<th>Balance</th>
					<th>pswd</th>
				</tr>";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
						"<td>" . $row[2] . "</td>" . 
						"<td>" . $row[3] . "</td>" . 
					"<tr>";
            }
            echo "</table>";
		}

        function handleInsertRequest() {
            global $db_conn;

            //Getting the values from user and insert data into the table
            $tuple = array (
                ":SIN" => $_POST['accountSIN'],
                ":fullName" => $_POST['accountFullName'],
                ":balance" => $_POST['accountBalance'],
                ":pswd" => $_POST['accountPassword'],
            );

            $alltuples = array (
                $tuple
            );

			echo "<br>ACCOUNTS BEFORE INSERT:</br>";
			printInsertRequestResult();

            executeBoundSQL("
				INSERT INTO Accounts (
					SIN,
                    fullName,
                    balance,
                    pswd
				) 
				VALUES (
					:SIN,
                    :fullName, 
					:balance, 
					:pswd 
                )", 
			$alltuples);
            
			echo "<br>ACCOUNTS AFTER INSERT:</br>";
			printInsertRequestResult();
            
            OCICommit($db_conn);
        }

		function printDeleteRequestResult() {
            $result = executePlainSQL("SELECT * FROM Stocks");

            echo "<br>Retrieved data from Stocks table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>InvestmentID</th>
					<th>RiskLevel</th>
					<th>Quantity</th>
					<th>Company</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
						"<td>" . $row[2] . "</td>" . 
						"<td>" . $row[3] . "</td>" . 
					"<tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
		}

        function handleDeleteRequest() {
            global $db_conn;

            $tuple = array (
                ":InvestmentID" => $_POST['deleteStockID'],
            );

            $alltuples = array (
                $tuple
            );

			echo "<br>BEFORE DELETE REQUEST: </br>";
			printDeleteRequestResult();

			executeBoundSQL("
				DELETE 
				FROM Stocks S
				WHERE S.InvestmentID = :InvestmentID
			", $alltuples);

			echo "<br>AFTER DELETE REQUEST: </br>";
			printDeleteRequestResult();
            
            OCICommit($db_conn);
		}

		function printUpdateAccountResult() {
            $result = executePlainSQL("
				SELECT * FROM Accounts
			");

            echo "<br>Retrieved data from Accounts table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>SIN</th>
					<th>fullName</th>
					<th>Balance</th>
					<th>pswd</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
						"<td>" . $row[2] . "</td>" . 
						"<td>" . $row[3] . "</td>" . 
					"<tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
		}

        function handleUpdateRequest() {
            global $db_conn;

            $tuple = array (
                ":SIN" => $_POST['updateSin'],
                ":Balance" => $_POST['updateBalance'],
            );

            $alltuples = array (
                $tuple
            );

			echo "<br>RESULT BEFORE UPDATE:</br>";
			printUpdateAccountResult();

			executeBoundSQL("
				UPDATE Accounts 
				SET Balance = :Balance
				WHERE SIN = :SIN
			", $alltuples);

			echo "<br>RESULT AFTER UPDATE:</br>";
			printUpdateAccountResult();
            
            OCICommit($db_conn);
		}

		function handleSelectionRequest() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT *
				FROM Accounts
				WHERE Balance >= 1000
			");

            echo "<br>Retrieved data from Accounts table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>SIN</th>
					<th>fullName</th>
					<th>Balance</th>
					<th>pswd</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
						"<td>" . $row[2] . "</td>" . 
						"<td>" . $row[3] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

		function handleProjectionRequest() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT DISTINCT Industry
				FROM Investments
			");

            echo "<br>Retrieved data from Investment table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Industry</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

		function handleJoinRequest() {
            global $db_conn;

			$query = "
				SELECT A.SIN, I.InvestmentID
				FROM Accounts A, Investments I, Contains C
				WHERE A.SIN = C.SIN
					AND C.InvestmentID = I.InvestmentID
					AND A.SIN = '" . $_GET['sinJoin'] . "'";

			$result = executePlainSQL($query);

            echo "<br>Retrieved data from Join:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>SIN</th>
					<th>InvestmentID</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

		function handleAggregationCountRequest() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT I.Industry, COUNT(*) AS NumInvestments
				FROM Investments I
				GROUP BY I.Industry
				ORDER BY NumInvestments DESC
			");

            echo "<br>Retrieved aggregate data from Investments:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Industry</th>
					<th>Number of Investments</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

        function handleAggregationCountRequest2() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT I.Industry, COUNT(*) AS NumInvestments
                FROM Investments I
                GROUP BY I.Industry
                HAVING COUNT(*) > 5
                ORDER BY NumInvestments DESC  
			");

            echo "<br>Retrieved aggregate data from Investments:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Industry</th>
					<th>Number of Investments</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}


        function handleNestedAggregationMaxAvgQuantity() {
            global $db_conn;

            // Define the SQL query with nested aggregation to find the maximum average quantity of investments across all industries
            $result = executePlainSQL("
                SELECT MAX(AvgQuantity) AS MaxAvgQuantity
                FROM (
                    SELECT Industry, AVG(Quantity) AS AvgQuantity
                    FROM Investments
                    GROUP BY Industry
                ) SubQuery
            ");

            // Output the result in HTML format
            echo "<br>Retrieved nested aggregate data:<br>";
            echo "<table>";
            echo "
                <tr>
                    <th>Maximum Average Quantity</th>
                </tr>
            ";

            // Fetch and display the result
            if ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["MAXAVGQUANTITY"] . "</td></tr>";
            } else {
                echo "<tr><td>No data found</td></tr>";
            }

            echo "</table>";
            
            // Commit any changes to the database
            OCICommit($db_conn);
        }

		function handleDivisionRequest() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT SIN FROM Accounts
                WHERE SIN IN (
                    SELECT C.SIN
                    FROM Contains C
                    JOIN Investments I ON C.InvestmentID = I.InvestmentID
                    WHERE I.Industry = '" . $_GET['industry1'] . "'
                    )
                INTERSECT
                SELECT SIN FROM Accounts
                    WHERE SIN IN (
                    SELECT C.SIN
                    FROM Contains C
                    JOIN Investments I ON C.InvestmentID = I.InvestmentID
                    WHERE I.Industry = '" . $_GET['industry2'] . "'
                )
			");

            echo "<br>Retrieved division data:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>SIN</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" .  
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

        function write_to_console($data) {
            $console = $data;
            if (is_array($console))
            $console = implode(',', $console);
            
            echo "<script>console.log('Console: " . $console . "' );</script>";
        }


        // HANDLE ALL POST ROUTES
	    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handlePOSTRequest() {
            if (connectToDB()) {
                if (array_key_exists('deleteStockRequest', $_POST)) {
                    handleDeleteRequest();
                } else if (array_key_exists('updateBalanceRequest', $_POST)) {
                    handleUpdateRequest();
                } else if (array_key_exists('insertAccountRequest', $_POST)) {
                    handleInsertRequest();
                } 


                disconnectFromDB();
            }
        }

        // HANDLE ALL GET ROUTES
        // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('submitHighBalance', $_GET)) {
                    handleSelectionRequest();
                } else if (array_key_exists('viewIndustriesSubmit', $_GET)) {
                    handleProjectionRequest();
                } else if (array_key_exists('joinInvestments', $_GET)) {
                    handleJoinRequest();
                } else if (array_key_exists('aggregateInvestments', $_GET)) {
                    handleAggregationCountRequest();
                } else if (array_key_exists('aggregateInvestments2', $_GET)) {
                    handleAggregationCountRequest2();
                } else if (array_key_exists('nestedAggregationSubmit', $_GET)) {
                    handleNestedAggregationMaxAvgQuantity();
                } else if (array_key_exists('divisionSubmit', $_GET)) {
                    handleDivisionRequest();
                } 

                disconnectFromDB();
            }
        }

		function handle() {
			if (isset($_POST['removeStockSubmit']) || isset($_POST['updateBalanceSubmit']) || isset($_POST['createAccountSubmit'])) {
				handlePOSTRequest();
			} else if (isset($_GET['highBalanceRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['distinctIndustriesRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['joinQueryRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['aggregationRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['aggregationRequest2'])) {
				handleGETRequest();
            } else if (isset($_GET['nestedAggregationRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['divisionRequest'])) {
				handleGETRequest();
			} 
		}
        
		?>
	</body>
</html>