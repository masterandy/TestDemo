/**************************************************************************************************
* Name: CSC_Parts
* Object: Parts_Order__c
* Purpose: 
* Parts_Order__c业务控制类
* Author: Ben
* Create Date: 2016-11-21
***************************************************************************************************/
global class CSC_Parts
{
    Map<String,String> idPartsmap = new Map<String,String>();

    //根据创建的Parts数据，来决定是否发送追加备件提醒
    public void CreateEntity(List<Parts_Order__c> poList)
    {
        Map<string,Entity> entity_map=new Map<string,Entity>();
        List<Entity> eList=new List<Entity>();
        Set<string> workorders=new Set<string>();
        List<String> offeredPartsIds = new List<String>();
        for(Parts_Order__c p:poList)
        {
            offeredPartsIds.add(p.Offered_Parts__c);
            string case_num = p.Name.substring(0,8);
            string num = p.Name.substring(9);
            Integer index = num.indexOf('-');
            Integer workorder_num = Integer.valueOf(num.substring(0,index));
            string str = num.substring(index+1);
            Integer order_index = str.indexOf('-'); 
            Integer order_num = Integer.valueOf(str.substring(0,order_index));  

            if(workorder_num > 1 || order_num > 1)   
            {
                workorders.add(case_num+'-1');
            }         
        }

        List<Parts__c> pl = [SELECT Id,Name FROM Parts__c where Id in:offeredPartsIds];
        for(Parts__c pc:pl){
            idPartsmap.put(pc.Id, pc.Name);
        }
        
        List<Workorder> woList=[Select Id,CreatedBy.Name,CreatedBy.Email,Work_Order_Name__c From Workorder Where Work_Order_Name__c in:workorders];
        system.debug('workorders:' + workorders);
        Map<string,Workorder> workorder_map=new Map<string,Workorder>();
        for(Workorder wo:woList)
        {
            workorder_map.put(wo.Work_Order_Name__c,wo);
        }
        
        if (!woList.isEmpty()){
            for(Parts_Order__c p:poList)
            {
                string case_num = p.Name.substring(0,8);
                string num = p.Name.substring(9);
                Integer index = num.indexOf('-');
                Integer workorder_num = Integer.valueOf(num.substring(0,index));
                string str = num.substring(index+1);
                Integer order_index = str.indexOf('-'); 
                Integer order_num = Integer.valueOf(str.substring(0,order_index));
                system.debug('workorder_map:' + workorder_map);
                system.debug('case_num:' + case_num);
                system.debug('test:' + workorder_map.get(case_num+'-1'));
                string dp_name = workorder_map.get(case_num+'-1').CreatedBy.Name;
                string dp_email = workorder_map.get(case_num+'-1').CreatedBy.Email;
                
                if((workorder_num > 1 || order_num > 1) && dp_name != userInfo.getName())   
                {
                    if(entity_map.containsKey(case_num))
                    {
                        Entity e = entity_map.get(case_num);
                        e.poList.add(p);
                    }
                    else
                    {
                        Entity e = new Entity();
                        e.dp_name = dp_name;
                        e.case_num = case_num;
                        e.dp_email = dp_email;
                        e.poList = new List<Parts_Order__c>();
                        e.poList.add(p);
                        
                        eList.add(e);
                        entity_map.put(case_num,e);
                    }
                }         
            }
        }
        
        if(eList.size() > 0)
        {
            SendEmail(eList);
        }
    }
    
    //发送追加备件邮件提醒
    public void SendEmail(List<Entity> eList)
    {    
        for(Entity e:eList)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {e.dp_email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('追加备件提醒 Case：'+ e.case_num);
            string parts_info='';
            for(Parts_Order__c p:e.poList)
            {
                parts_info+='备件号:'+idPartsmap.get(p.Offered_Parts__c)+','+'备件描述:'+p.Parts_Description_Text__c+'<br/>';
            }
            // system.now().format('yyyy-MM-dd HH:mm:ss','Asia/Shanghai');
            mail.setHtmlBody('Hi '+e.dp_name+':'+'<br/>'+'<p>Case:<b>'+e.case_num+'</b>在 '+System.now().format('yyyy-MM-dd HH:mm:ss','Asia/Shanghai')+' 由 <b>'+userInfo.getName()+'</b> 追加备件。'+'<br/>'+
                                '备件信息：'+'<br/>'+parts_info+'</p>');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});     
        }
    }
    
    //内部类用于构造发送Email对象
    public class Entity
    {
        public string dp_name;
        public string case_num;
        public string dp_email;
        public List<Parts_Order__c> poList;
    }
}