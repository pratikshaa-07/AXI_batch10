class environment extends uvm_env;
  active_agent act_agt;
  passive_agent pas_agt;
  scoreboard scb;
  //subscriber sub;

  `uvm_component_utils(environment)
  
  function new(string name="environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a_agt=passive_agent::type_id::create("act_agt",this);
    p_agt=active_agent::type_id::create("pas_agt",this);
    scb=scoreboard::type_id::create("scb",this);
    //sub=subscriber::type_id::create("sub",this); 
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);    
    act_agt.monitor.send_port.connect(scb.wrt_fifo.analysis_export);
    //act_agt.monitor.mon_port.connect(sub.cov_port.analysis_export);
    
    pas_agt.monitor.send_port.connect(scb.rd_fifo.analysis_export);
    //pas_agt.monitor.mon_port.connect(sub.cov_port.analysis_export);
    
    endfunction
endclass
      
