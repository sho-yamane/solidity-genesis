pragma solidity ^0.4.11;

contract HelloEthereum {
  // コメント
  string public msg1;
  string private msg2;
  address public owner;
  uint8 public counter;

  // コンストラクタ
  function HelloEthereum(string _msg1) public {
    // msg1に_msg1を設定
    msg1 = _msg1;

    // ownerに本コンストラクトを生成したアドレスを設定
    owner = msg.sender;

    // counterに初期値として0を設定
    counter = 0;
  }

  // msg2のsetter
  function setMsg2(string _msg2) public {
    // if
    if(owner != msg.sender) {
      require(msg.sender == owner);
    } else {
      msg2 = _msg2;
    }
  }

  // msg2のgetter
  function getMsg2() constant public returns(string) {
    return msg2;
  }

  function setCounter() public {
    for(uint8 i = 0; i < 3; i++) {
      counter++;
    }
  }

}
