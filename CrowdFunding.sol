pragma solidity ^0.4.11;

contract CrowdFunding {
    // 投資家
    struct Investor {
        address addr;   // 投資家のアドレス
        uint amount;    // 投資額
    }

    address public owner;       // コントラクトのオーナー
    uint public numInvestors;   // 投資家の数
    uint public deadline;       // 締め切り（UnixTime）
    string public status;       // キャンペーンのステータス
    bool public ended;          // キャンペーンが終了しているかどうか
    uint public goalAmount;     // 目標額
    uint public totalAmount;    // 投資の総額
    bool public to;             // 送金できたかどうか
    mapping (uint => Investor) public investors; // 投資家管理用のマップ

    modifier onlyOwner () {
        require(msg.sender == owner);
        _;
    }

    /// コンストラクタ（durationは期間）
    function CrowdFunding(uint _duration, uint _goalAmount) public {
        owner = msg.sender;

        // 締め切りをUnixtimeで設定
        deadline = now + _duration;

        goalAmount = _goalAmount;
        status = "Founding";
        ended = false;

        numInvestors = 0;
        totalAmount = 0;
    }

    /// 投資する際に呼出される関数
    function fund() public payable {
        // キャンペーンが終わってたら処理を中断
        require(!ended); // Falseの場合終了

        Investor storage inv = investors[numInvestors++];
        inv.addr = msg.sender;
        inv.amount = msg.value;
        totalAmount += inv.amount;
    }

    /// 目標額に達したかを確認する
    /// また、キャンペーンの成功/失敗に応じたetherの送金を行う
    function checkGoalReaached () public onlyOwner {
        // キャンペーンが終わっていれば処理を中断
        require(!ended);  // Falseの場合終了

        // 締切の前の場合は処理を中断する
        require(now >= deadline); // Falseの場合終了
        if (totalAmount >= goalAmount) {
            status = "Campaign Succeed";
            ended = true;
            // オーナーにコントラクト内のすべてのetherを送金する
            to = owner.send(this.balance);
            require(to);
        } else {
            uint i = 0;
            status = "Campaign Failed";
            ended = true;

            // 投資家毎にetherを返金する
            while(i <= numInvestors) {
                to = investors[i].addr.send(investors[i].amount);
                require(to);
                i++;
            }
        }
    }

    function kill() public onlyOwner {
        selfdestruct(owner);
    }
}
