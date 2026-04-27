import logging
from typing import Dict, Any

# Devopstrio App Landing Zone
# Governance Engine - Provisioning Policy Evaluation

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - GOVERNANCE - %(message)s")
logger = logging.getLogger(__name__)

class ProvisioningGovernanceEngine:
    def __init__(self):
        self.allowed_regions = ["uksouth", "ukwest"]
        self.mandatory_tags = ["CostCenter", "Environment", "OwnerEmail"]
        
    def evaluate_request(self, request_payload: Dict[str, Any]) -> dict:
        """
        Validates an incoming application provisioning request against global landing zone policies.
        Called continuously by the Platform API before triggering Terraform pipelines.
        """
        logger.info(f"Evaluating provisioning request for App: {request_payload.get('app_name', 'Unknown')}")
        
        score = 100
        violations = []
        
        # 1. Region Policy
        req_region = request_payload.get("region")
        if req_region not in self.allowed_regions:
            violations.append(f"Region '{req_region}' is restricted. Allowed: {self.allowed_regions}")
            score -= 50
            
        # 2. Tagging Policy (Simulation for payload)
        req_tags = request_payload.get("tags", {})
        for tag in self.mandatory_tags:
            if tag not in req_tags:
                violations.append(f"Missing mandatory tag: '{tag}'")
                score -= 15
                
        # 3. Environment Restrictions
        if request_payload.get("environment") == "prod" and request_payload.get("business_criticality", 0) < 3:
            violations.append("Production environments require a minimum business criticality score of 3.")
            score -= 20
        
        status = "APPROVED" if score >= 80 else "REJECTED"
        logger.info(f"Evaluation Complete. Score: {score} | Status: {status}")
        
        return {
            "status": status,
            "score": score,
            "violations": violations
        }

if __name__ == "__main__":
    logger.info("Starting Governance Evaluation Worker Thread...")
    engine = ProvisioningGovernanceEngine()
    
    mock_payload = {
        "app_name": "Core-Banking-Facade",
        "region": "uksouth",
        "environment": "prod",
        "business_criticality": 5,
        "tags": {"Environment": "prod", "CostCenter": "772"} # Missing OwnerEmail
    }
    
    result = engine.evaluate_request(mock_payload)
    print(f"Engine Result: {result}")
